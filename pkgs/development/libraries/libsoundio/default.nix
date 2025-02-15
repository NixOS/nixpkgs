{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  libjack2,
  libpulseaudio,
  AudioUnit,
}:

stdenv.mkDerivation rec {
  version = "2.0.1-7";
  pname = "libsoundio";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = version;
    sha256 = "sha256-JQ6TH6zf1wNb4al0v5MgcR12KQL6CKSVXbf1KKJevwA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [ libjack2 ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libpulseaudio
      alsa-lib
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin AudioUnit;

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DBUILD_TESTS=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-strict-prototypes";

  meta = with lib; {
    description = "Cross platform audio input and output";
    homepage = "http://libsound.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
