{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-corner-preview";
  version = "unstable-2019-02-27";

  src = fetchFromGitHub {
    owner = "medenagan";
    repo = "window-corner-preview";
    rev = "9c1e97c7f7ecd530abac572050f6ec89c1ac7571";
    sha256 = "12yx3zfnqkpy9g8mhniw02q61axgb14aqiyj6pdfcdmd6hrgsmz6";
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
