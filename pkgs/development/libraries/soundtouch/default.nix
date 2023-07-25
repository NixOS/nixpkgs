{ stdenv, lib, fetchFromGitea, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "soundtouch";
  version = "2.3.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "soundtouch";
    repo = "soundtouch";
    rev = version;
    sha256 = "sha256-+RprzCn0NCueHhDkk2Lgg7Ihw8JDzu25eIVoVZwF+BA=";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  preConfigure = "./bootstrap";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A program and library for changing the tempo, pitch and playback rate of audio";
    homepage = "https://www.surina.net/soundtouch/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "soundstretch";
    platforms = platforms.all;
  };
}
