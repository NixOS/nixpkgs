{ stdenv, fetchurl, pkgconfig, libxml2, glib, gtk3, enchant2, isocodes, vala, gobjectIntrospection, gnome3 }:

let
  pname = "gspell";
  version = "1.8.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0ickabxngl567lv1jax4fasr5brq29hg04ymaay47pjfp32w4zqv";
  };

  propagatedBuildInputs = [ enchant2 ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig vala gobjectIntrospection libxml2 ];
  buildInputs = [ glib gtk3 isocodes ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A spell-checking library for GTK+ applications";
    homepage = https://wiki.gnome.org/Projects/gspell;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
