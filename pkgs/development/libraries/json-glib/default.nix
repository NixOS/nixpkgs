{ stdenv, fetchurl, fetchpatch, glib, meson, ninja, pkgconfig, gettext
, gobjectIntrospection, dbus
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  name = "json-glib-${minVer}.2";
  minVer = "1.4";

  src = fetchurl {
    url = "mirror://gnome/sources/json-glib/${minVer}/${name}.tar.xz";
    sha256 = "2d7709a44749c7318599a6829322e081915bdc73f5be5045882ed120bb686dc8";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ meson ninja pkgconfig gettext gobjectIntrospection ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  patches = [
    # https://gitlab.gnome.org/GNOME/json-glib/issues/27
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/json-glib/merge_requests/2.diff";
      sha256 = "0pf006jxj1ki7a0w4ykxm6b24m0wafrhpdcmixsw9x83m227156c";
    })
  ];

  outputs = [ "out" "dev" ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lethalman ];
    platforms = with platforms; unix;
  };
}
