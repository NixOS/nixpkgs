{ stdenv, lib, fetchFromGitea, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "soundtouch";
  version = "2.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "soundtouch";
    repo = "soundtouch";
    rev = version;
    sha256 = "10znckb8mrnmvwj7vq12732al873qhqw27fpb5f8r0bkjdpcj3vr";
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
