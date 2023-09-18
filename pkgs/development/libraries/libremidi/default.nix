{ lib
, stdenv
, fetchFromGitHub

, alsa-lib
, cmake
, CoreAudio
, CoreFoundation
, CoreMIDI
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "libremidi";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "jcelerier";
    repo = "libremidi";
    rev = "v${version}";
    hash = "sha256-aO83a0DmzwjYXDlPIsn136EkDF0406HadTXPoGuVF6I=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    CoreAudio
    CoreFoundation
    CoreMIDI
    CoreServices
  ];

  postInstall = ''
    cp -r $src/include $out
  '';

  meta = with lib; {
    description = "A modern C++ MIDI real-time & file I/O library";
    homepage = "https://github.com/jcelerier/libremidi";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ paveloom ];
  };
}
