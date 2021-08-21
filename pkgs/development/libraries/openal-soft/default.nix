{ lib, stdenv, fetchFromGitHub, cmake
, alsaSupport ? !stdenv.isDarwin, alsa-lib ? null
, pulseSupport ? !stdenv.isDarwin, libpulseaudio ? null
, CoreServices, AudioUnit, AudioToolbox
}:

with lib;

assert alsaSupport -> alsa-lib != null;
assert pulseSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "1.21.1";
  pname = "openal-soft";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = version;
    sha256 = "sha256-rgc6kjXaZb6sCR+e9Gu7BEEHIiCHMygpLIeSqgWkuAg=";
  };

  # this will make it find its own data files (e.g. HRTF profiles)
  # without any other configuration
  patches = [ ./search-out.patch ];
  postPatch = ''
    substituteInPlace alc/helpers.cpp \
      --replace "@OUT@" $out
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = []
    ++ optional alsaSupport alsa-lib
    ++ optional pulseSupport libpulseaudio
    ++ optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  NIX_LDFLAGS = toString ([]
    ++ optional alsaSupport "-lasound"
    ++ optional pulseSupport "-lpulse");

  meta = {
    description = "OpenAL alternative";
    homepage = "https://kcat.strangesoft.net/openal.html";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
