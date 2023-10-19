{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dj2fj1dsdAMl/H0vNKTf9qjPB4GVRpgWPVR+PuZWZMc=";
  };

  postPatch = ''
    substituteInPlace janet.1 \
      --replace /usr/local/ $out/
  '';

  nativeBuildInputs = [ meson ninja ];

  mesonBuildType = "release";
  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/janet -e '(+ 1 2 3)'
  '';

  meta = with lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewchambers peterhoeg ];
    platforms = platforms.all;
  };
}
