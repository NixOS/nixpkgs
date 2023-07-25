{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, autoreconfHook
, strace
, which
}:

stdenv.mkDerivation rec {
  pname = "libeatmydata";
  version = "131";

  src = fetchFromGitHub {
    owner = "stewartsmith";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-0lrYDW51/KSr809whGwg9FYhzcLRfmoxipIgrK1zFCc=";
  };

  patches = [
    # Fixes "error: redefinition of 'open'" on musl
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/861ac185a6b60134292ff93d40e40b5391d0aa8e/srcpkgs/libeatmydata/patches/musl.patch";
      hash = "sha256-MZfTgf2Qn94UpPlYNRM2zK99iKQorKQrlbU5/1WJhJM=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  nativeCheckInputs = [
    strace
    which
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small LD_PRELOAD library to disable fsync and friends";
    homepage = "https://www.flamingspork.com/projects/libeatmydata/";
    license = licenses.gpl3Plus;
    mainProgram = "eatmydata";
    platforms = platforms.unix;
  };
}
