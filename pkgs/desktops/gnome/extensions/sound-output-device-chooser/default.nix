{ lib, stdenv
, substituteAll
, fetchFromGitHub
, libpulseaudio
, python3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "38";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = version;
    sha256 = "sha256-LZ+C9iK+j7+DEscYCIObxXc0Bn0Z0xSsEFMZxc8REWA=";
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

  passthru = {
    extensionUuid = "sound-output-device-chooser@kgshank.net";
    extensionPortalSlug = "sound-output-device-chooser";
  };

  makeFlags = [
    "INSTALL_DIR=${placeholder "out"}/share/gnome-shell/extensions"
  ];

  preInstall = ''
    mkdir -p ${placeholder "out"}/share/gnome-shell/extensions
  '';

  meta = with lib; {
    description = "GNOME Shell extension adding audio device chooser to panel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/kgshank/gse-sound-output-device-chooser";
  };
}
