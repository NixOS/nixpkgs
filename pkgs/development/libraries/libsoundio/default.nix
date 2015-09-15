{ stdenv, fetchFromGitHub, cmake, alsaLib, libjack2-git, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  name = "libsoundio-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = "${version}";
    sha256 = "1nlsn517rqvhc1scfw96ky7ja6dj2l96j4qjrphb5z63zxxi06pf";
  };

  buildInputs = [ cmake alsaLib libjack2-git libpulseaudio ];

  meta = with stdenv.lib; {
    description = "Cross platform audio input and output";
    homepage = http://libsound.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
