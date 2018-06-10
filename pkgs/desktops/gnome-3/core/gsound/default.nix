{ stdenv, fetchurl, pkgconfig, glib, libcanberra, gobjectIntrospection, libtool, gnome3 }:

let
  pname = "gsound";
  version = "1.0.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "bba8ff30eea815037e53bee727bbd5f0b6a2e74d452a7711b819a7c444e78e53";
  };

  nativeBuildInputs = [ pkgconfig gobjectIntrospection libtool gnome3.vala ];
  buildInputs = [ glib libcanberra ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GSound;
    description = "Small library for playing system sounds";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
