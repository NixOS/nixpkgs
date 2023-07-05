{ alsa-lib
, cmake
, CoreAudio
, CoreFoundation
, CoreMIDI
, CoreServices
, fetchFromGitHub
, lib
, stdenv
}:

stdenv.mkDerivation {
  pname = "libremidi";
  version = "unstable-2023-05-05";

  src = fetchFromGitHub {
    owner = "jcelerier";
    repo = "libremidi";
    rev = "cd2e52d59c8ecc97d751619072c4f4271fa82455";
    hash = "sha256-CydoCprxqDl5FXjtgT+AckaRTqQAlCDwwrnPDK17A6o=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.isLinux alsa-lib
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
    description = "A modern C++ MIDI real-time & file I/O library";
    homepage = "https://github.com/jcelerier/libremidi";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
}
