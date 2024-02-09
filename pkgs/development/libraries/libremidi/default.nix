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

stdenv.mkDerivation rec {
  pname = "libremidi";
  version = "4.2.4";

  src = fetchFromGitHub {
    owner = "jcelerier";
    repo = "libremidi";
    rev = "v${version}";
    hash = "sha256-AWONCZa4tVZ7HMze9WSVzHQUXIrn1i6ZZ4Hgufkrep8=";
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
    maintainers = [ ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
}
