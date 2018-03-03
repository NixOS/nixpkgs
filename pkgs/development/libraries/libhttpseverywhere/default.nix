{ stdenv, fetchurl, pkgconfig, meson, ninja, valadoc
, gnome3, glib, json-glib, libarchive, libsoup, gobjectIntrospection }:

let
  pname = "libhttpseverywhere";
  version = "0.6.5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0ksf6vqjyjii29dvy5147dmgqlqsq4d70xxai0p2prkx4jrwgj3z";
  };

  nativeBuildInputs = [ gnome3.vala gobjectIntrospection meson ninja pkgconfig valadoc ];
  buildInputs = [ glib gnome3.libgee json-glib libsoup libarchive ];

  mesonFlags = [ "-Denable_valadoc=true" ];

  doCheck = true;

  checkPhase = "./httpseverywhere_test";

  outputs = [ "out" "devdoc" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Library to use HTTPSEverywhere in desktop applications";
    homepage = https://git.gnome.org/browse/libhttpseverywhere;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sternenseemann ] ++ gnome3.maintainers;
  };
}
