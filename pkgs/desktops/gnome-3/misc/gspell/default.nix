{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes, vala, gobjectIntrospection, gnome3 }:

stdenv.mkDerivation rec {
  name = "gspell-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0ickabxngl567lv1jax4fasr5brq29hg04ymaay47pjfp32w4zqv";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gspell"; attrPath = "gnome3.gspell"; };
  };

  propagatedBuildInputs = [ enchant ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig vala gobjectIntrospection ];
  buildInputs = [ glib gtk3 isocodes ];

  meta = with stdenv.lib; {
    description = "A spell-checking library for GTK+ applications";
    homepage = https://wiki.gnome.org/Projects/gspell;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
