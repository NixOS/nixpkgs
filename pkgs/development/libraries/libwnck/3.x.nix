{ stdenv, fetchurl, pkgconfig, libX11, gtk3, intltool, gobject-introspection, gnome3 }:

let
  pname = "libwnck";
  version = "3.30.0";
in stdenv.mkDerivation rec{
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0f9lvhm3w25046dqq8xyg7nzggxpmdriwrb661nng05a8qk0svdc";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  configureFlags = [ "--enable-introspection" ];

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];
  propagatedBuildInputs = [ libX11 gtk3 ];

  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "dev"}/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.worldofpeace ];
  };
}
