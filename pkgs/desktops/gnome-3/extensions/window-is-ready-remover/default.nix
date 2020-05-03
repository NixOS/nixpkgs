{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-is-ready-remover";
  version = "unstable-2020-03-25";

  src = fetchFromGitHub {
    owner = "nunofarruca";
    repo = "WindowIsReady_Remover";
    rev = "a9f9b3a060a6ba8eec71332f39dc2569b6e93761";
    sha256 = "0l6cg9kz2plbvsqhgwfajknzw9yv3mg9gxdbsk147gbh2arnp6v3";
  };

  uuid = "windowIsReady_Remover@nunofarruca@gmail.com";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r ${uuid} $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "GNOME Shell extension removing window is ready notification";
    homepage = "https://github.com/nunofarruca/WindowIsReady_Remover";
    license = licenses.unfree;
  };
}
