{ lib
, stdenv
, fetchFromGitHub
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
    # https://github.com/stewartsmith/libeatmydata/pull/36
    ./LFS64.patch
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
