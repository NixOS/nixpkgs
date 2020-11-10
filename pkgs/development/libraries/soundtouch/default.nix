{stdenv, lib, fetchFromGitLab, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  pname = "soundtouch";
  version = "2.1.2";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "174wgm3s0inmbnkrlnspxjwm2014qhjhkbdqa5r8rbfi0nzqxzsz";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  preConfigure = "./bootstrap";

  meta = with lib; {
    description = "A program and library for changing the tempo, pitch and playback rate of audio";
    homepage = "http://www.surina.net/soundtouch/";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
