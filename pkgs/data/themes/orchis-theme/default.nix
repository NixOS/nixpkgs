{ stdenv, fetchFromGitHub, gtk3, gnome-themes-extra, gtk-engine-murrine, bc }:
stdenv.mkDerivation rec {
  pname = "orchis-theme";
  version = "unstable-2020-10-25";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = "6369f17e4b98599bb8113b52e4ed6ca7bd20103e";
    sha256 = "1l3icm7z8rq962bp47kklgivi2hlxnmv99q06h0qz7nsp0jaimzi";
  };

  nativeBuildInputs = [ gtk3 bc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  patchPhase = ''patchShebangs install.sh'';

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh --dest $out/share/themes
  '';
    
  meta = with stdenv.lib; {
    description = "Orchis is a theme for GNOME/GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Orchis-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-ihought ];
  };

}
