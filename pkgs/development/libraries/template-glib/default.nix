{ stdenv, fetchurl, glib, meson, ninja, pkgconfig, bison, flex, gettext
, gobjectIntrospection, fixDarwinDylibNames, gnome3, vala
}:

let
  pname = "template-glib";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "18bic41f9cx8h6n5bz80z4ridb8c1h1yscicln8zsn23zmp44x3c";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ meson ninja pkgconfig bison flex gettext gobjectIntrospection vala ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  outputs = [ "out" "dev" ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library for template expansion which supports calling into GObject Introspection from templates";
    homepage = https://gitlab.gnome.org/GNOME/template-glib;
    license = licenses.lgpl2;
    platforms = with platforms; unix;
  };
}
