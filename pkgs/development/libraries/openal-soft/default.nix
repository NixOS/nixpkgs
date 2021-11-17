{ lib, stdenv, fetchFromGitHub, cmake
, alsaSupport ? !stdenv.isDarwin, alsa-lib
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, CoreServices, AudioUnit, AudioToolbox
}:

stdenv.mkDerivation rec {
  pname = "openal-soft";
  version = "1.21.1";

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

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) stdenv.cc.libc
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  NIX_LDFLAGS = toString (
    lib.optional alsaSupport "-lasound"
    ++ lib.optional pulseSupport "-lpulse");

  meta = with lib; {
    description = "OpenAL alternative";
    homepage = "https://kcat.strangesoft.net/openal.html";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
