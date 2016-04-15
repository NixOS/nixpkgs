{ stdenv, fetchurl, pkgconfig, gtk, intltool, xorg }:

let
  ver_maj = "2.31";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libwnck-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${ver_maj}/${name}.tar.xz";
    sha256 = "17isfjvrzgj5znld2a7zsk9vd39q9wnsysnw5jr8iz410z935xw3";
  };

  outputs = [ "dev" "out" "docdev" ];
  outputBin = "dev";

  buildInputs = [ pkgconfig gtk intltool xorg.libX11 xorg.libXres ];
  # ?another optional: startup-notification

  configureFlags = [ "--disable-introspection" ]; # not needed anywhere AFAIK

  meta = {
    description = "A library for creating task lists and pagers";
    license = stdenv.lib.licenses.lgpl21;
  };
}
