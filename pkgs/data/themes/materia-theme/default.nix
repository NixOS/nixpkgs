{ stdenv, fetchFromGitHub, gnome3, glib, libxml2, gtk-engine-murrine, gdk-pixbuf, librsvg, bc }:

stdenv.mkDerivation rec {
  pname = "materia-theme";
  version = "20190831";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = pname;
    rev = "v${version}";
    sha256 = "19b2wyq38wj3id0an47jln1y3zp5ih3kbrgmfpjp6bbdrmfcyccf";
  };

  nativeBuildInputs = [ glib libxml2 bc ];

  buildInputs = [ gnome3.gnome-themes-extra gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    patchShebangs install.sh
    sed -i install.sh \
      -e "s|if .*which gnome-shell.*;|if true;|" \
      -e "s|CURRENT_GS_VERSION=.*$|CURRENT_GS_VERSION=${stdenv.lib.versions.majorMinor gnome3.gnome-shell.version}|"
    ./install.sh --dest $out/share/themes
    rm $out/share/themes/*/COPYING
  '';

  meta = with stdenv.lib; {
    description = "Material Design theme for GNOME/GTK+ based desktop environments";
    homepage = https://github.com/nana-4/materia-theme;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.mounium ];
  };
}
