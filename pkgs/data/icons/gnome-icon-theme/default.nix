{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk2 }:

stdenv.mkDerivation rec {
  pname = "gnome-icon-theme";
  version = "3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fjh9qmmgj34zlgxb09231ld7khys562qxbpsjlaplq2j85p57im";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    iconnamingutils
    gtk2
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    # remove a tree of dirs with no files within
    rm -r "$out/share/locale"
  '';

  meta = with stdenv.lib; {
    description = "Collection of icons for the GNOME 2 desktop";
    homepage = "https://download.gnome.org/sources/gnome-icon-theme/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
