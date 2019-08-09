{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-sound-output-device-chooser";
  version = "unstable-2019-04-01";

  src = fetchFromGitHub {
    owner = "kgshank";
    repo = "gse-sound-output-device-chooser";
    rev = "37098909a50bafe2f2538819f988cb2327ed7c60";
    sha256 = "09sbby8zi9xn21lbdry57bp1vwgd5c73anvqpw9css3x2ryda5li";
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
