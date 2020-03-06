{ stdenv
, substituteAll
, fetchFromGitHub
, libpulseaudio
, python3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "25";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = version;
    sha256 = "16xaa4r01575ix9lrvww8n6pird8r3ml1j037b3sm6dfrf8kvzxs";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libpulse = "${libpulseaudio}/lib/libpulse.so";
      python = python3.interpreter;
    })
  ];

  dontBuild = true;

  uuid = "sound-output-device-chooser@kgshank.net";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "GNOME Shell extension adding audio device chooser to panel";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/kgshank/gse-sound-output-device-chooser";
  };
}
