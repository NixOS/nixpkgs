{
  lib,
  stdenv,
  substituteAll,
  fetchFromGitHub,
  libpulseaudio,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  # For gnome 42 support many commits not tagged yet are needed.
  version = "unstable-2022-03-29";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = "76f7f59d23f5ffcd66555c7662f43c9cc1ce4742";
    sha256 = "sha256-iPc95LmDsYizLg45wpU+vFx/N6MR2hewSHqoRsePC/4=";
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
    maintainers = [ ];
    homepage = "https://github.com/kgshank/gse-sound-output-device-chooser";
  };
}
