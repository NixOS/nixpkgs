{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "noise-suppression-for-voice-unstable";
  version = "2020-10-10";

  src = fetchFromGitHub {
    owner = "werman";
    repo = "noise-suppression-for-voice";
    rev = "15bac8f34018184d7d4de1b3b2ba98c433705f6c";
    sha256 = "11pwisbcks7g0mdgcrrv49v3ci1l6m26bbb7f67xz4pr1hai5dwc";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A real-time noise suppression plugin for voice";
    longDescription = ''
The plugin is meant to suppress a wide range of noise origins (from original paper): computer fans, office, crowd, airplane, car, train, construction.
    '';
    homepage = "https://github.com/werman/noise-suppression-for-voice";
    license = licenses.gpl3;
    maintainers = [ maintainers.henrikolsson ];
    platforms = platforms.all;
  };
}
