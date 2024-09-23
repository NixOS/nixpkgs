{ alsa-lib
, cmake
, darwin
, fetchFromGitHub
, lib
, stdenv
}:

let
  inherit (darwin.apple_sdk.frameworks)
    CoreAudio
    CoreFoundation
    CoreMIDI
    CoreServices;
in
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

  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
