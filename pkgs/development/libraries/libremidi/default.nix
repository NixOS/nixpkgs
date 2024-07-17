{
  alsa-lib,
  cmake,
  CoreAudio,
  CoreFoundation,
  CoreMIDI,
  CoreServices,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libremidi";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "jcelerier";
    repo = "libremidi";
    rev = "v${version}";
    hash = "sha256-raVBJ75/UmM3P69s8VNUXRE/2jV4WqPIfI4eXaf6UEg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    lib.optional stdenv.isLinux alsa-lib
    ++ lib.optionals stdenv.isDarwin [
      CoreAudio
      CoreFoundation
      CoreMIDI
      CoreServices
    ];

  postInstall = ''
    cp -r $src/include $out
  '';

  meta = {
    description = "Modern C++ MIDI real-time & file I/O library";
    homepage = "https://github.com/jcelerier/libremidi";
    maintainers = [ ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
}
