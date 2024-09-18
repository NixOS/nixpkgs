{ lib, stdenv, fetchurl, pkg-config, gtk2, intltool, xorg }:

stdenv.mkDerivation rec {
  pname = "libwnck";
  version = "2.31.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17isfjvrzgj5znld2a7zsk9vd39q9wnsysnw5jr8iz410z935xw3";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ gtk2 xorg.libX11 xorg.libXres ];
  # ?another optional: startup-notification

  configureFlags = [ "--disable-introspection" ]; # not needed anywhere AFAIK

  meta = {
    description = "Library for creating task lists and pagers";
    homepage = "https://gitlab.gnome.org/GNOME/libwnck";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ johnazoidberg ];
    # ./xutils.h:31:10: fatal error: 'gdk/gdkx.h' file not found
    # #include <gdk/gdkx.h>
    broken = stdenv.isDarwin;
  };
}
