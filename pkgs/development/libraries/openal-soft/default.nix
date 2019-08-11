{ stdenv, fetchFromGitHub, cmake
, alsaSupport ? !stdenv.isDarwin, alsaLib ? null
, pulseSupport ? !stdenv.isDarwin, libpulseaudio ? null
, CoreServices, AudioUnit, AudioToolbox
}:

with stdenv.lib;

assert alsaSupport -> alsaLib != null;
assert pulseSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "1.19.1";
  name = "openal-soft-${version}";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = name;
    sha256 = "0b0g0q1c36nfb289xcaaj3cmyfpiswvvgky3qyalsf9n4dj7vnzi";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = []
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  NIX_LDFLAGS = []
    ++ optional alsaSupport "-lasound"
    ++ optional pulseSupport "-lpulse";

  meta = {
    description = "OpenAL alternative";
    homepage = https://kcat.strangesoft.net/openal.html;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
