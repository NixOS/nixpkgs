{ stdenv, fetchurl, meson, ninja, pkgconfig, exiv2, glib, gnome3, gobjectIntrospection, vala }:

let
  pname = "gexiv2";
  version = "0.10.8";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0088m7p044n741ly1m6i7w25z513h9wpgyw0rmx5f0sy3vyjiic1";
  };

  preConfigure = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection vala ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ exiv2 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/gexiv2;
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
