{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, glib, gtk-doc, gtk, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "gtk-mac-integration";
  version = "3.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0sc0m3p8r5xfh5i4d7dg72kfixx9yi4f800y43bszyr88y52jkga";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config gtk-doc gobject-introspection ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ gtk ];

  preAutoreconf = ''
    gtkdocize
  '';

  meta = with lib; {
    description = "Provides integration for GTK applications into the Mac desktop";
    license = licenses.lgpl21;
    homepage = "https://gitlab.gnome.org/GNOME/gtk-mac-integration";
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.darwin;
  };
}
