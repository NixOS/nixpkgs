{ lib, stdenv
, substituteAll
, fetchFromGitHub
, libpulseaudio
, python3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "35";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = version;
    sha256 = "sha256-Yl5ut6kJAkAAdCBiNFpwDgshXCLMmFH3/zhnFGpyKqs=";
  };

  patches = [
    # Fix paths to libpulse and python
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

  meta = with lib; {
    description = "GNOME Shell extension adding audio device chooser to panel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/kgshank/gse-sound-output-device-chooser";
  };
}
