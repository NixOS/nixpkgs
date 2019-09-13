{ stdenv, fetchFromGitHub, cmake, alsaLib, libjack2, libpulseaudio, AudioUnit }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  pname = "libsoundio";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = version;
    sha256 = "12l4rvaypv87vigdrmjz48d4d6sq4gfxf5asvnc4adyabxb73i4x";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libjack2 libpulseaudio ]
    ++ stdenv.lib.optional stdenv.isLinux alsaLib
    ++ stdenv.lib.optional stdenv.isDarwin AudioUnit;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-Wno-strict-prototypes";

  meta = with stdenv.lib; {
    description = "Cross platform audio input and output";
    homepage = http://libsound.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
