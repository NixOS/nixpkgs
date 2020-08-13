{ stdenv
, substituteAll
, fetchFromGitHub
, libpulseaudio
, python3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "28";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = version;
    sha256 = "1vmf8mgb52x7my3sidaw8kh26d5niadn18bgrl6bjcakmj5x8q16";
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
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "GNOME Shell extension adding audio device chooser to panel";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/kgshank/gse-sound-output-device-chooser";
  };
}
