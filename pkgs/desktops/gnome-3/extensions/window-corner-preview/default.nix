{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-corner-preview";
  version = "unstable-2019-04-03";

  src = fetchFromGitHub {
    owner = "medenagan";
    repo = "window-corner-preview";
    rev = "a95bb1389d94474efab7509aac592fb58fff6006";
    sha256 = "03v18j9l0fb64xrg3swf1vcgl0kpgwjlp8ddn068bpvghrsvgfah";
  };

  dontBuild = true;

  uuid = "window-corner-preview@fabiomereu.it";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "GNOME Shell extension showing a video preview on the corner of the screen";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    homepage = https://github.com/medenagan/window-corner-preview;
  };
}
