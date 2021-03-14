{ lib, stdenv
, substituteAll
, fetchFromGitHub
, libpulseaudio
, python3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "32";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = version;
    sha256 = "1s83scr80qv5xmlfsy6dnsj96lwg2rr4pbsw9inld3ylblgvi35l";
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

  meta = with lib; {
    description = "GNOME Shell extension adding audio device chooser to panel";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/kgshank/gse-sound-output-device-chooser";
  };
}
