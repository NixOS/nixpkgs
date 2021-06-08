{ lib, stdenv, fetchFromGitHub, cmake
, alsaSupport ? !stdenv.isDarwin, alsaLib ? null
, pulseSupport ? !stdenv.isDarwin, libpulseaudio ? null
, CoreServices, AudioUnit, AudioToolbox
}:

with lib;

assert alsaSupport -> alsaLib != null;
assert pulseSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "1.21.1";
  pname = "openal-soft";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = "${version}";
    sha256 = "025qlh2sm4l75hljhcw740i0fh84pdmz97hz16nbwrfs6n93l1xf";
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
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  NIX_LDFLAGS = toString ([]
    ++ optional alsaSupport "-lasound"
    ++ optional pulseSupport "-lpulse");

  meta = {
    description = "Software implementation of OpenAL";
    homepage = "https://kcat.tomasu.net/openal.html";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
