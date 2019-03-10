{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "unstable-2019-03-10";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = "26c66da6795104802f3240bd9f5741f64367c8e7";
    sha256 = "153cdd0pip4nbpc2a9y1v3y7qivafv3wk296zqdamcjrd0p94nqz";
  };

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
    homepage = https://github.com/kgshank/gse-sound-output-device-chooser;
  };
}
