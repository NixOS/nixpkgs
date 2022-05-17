{stdenv, lib, fetchFromGitLab, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  pname = "soundtouch";
  version = "2.2";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "12i6yg8vvqwyk412lxl2krbfby6hnxld8qxy0k4m5xp4g94jiq4p";
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
