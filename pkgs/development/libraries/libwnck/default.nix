{ stdenv, fetchurl, pkgconfig, gtk2, intltool, xorg }:

stdenv.mkDerivation rec {
  pname = "libwnck";
  version = "2.31.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17isfjvrzgj5znld2a7zsk9vd39q9wnsysnw5jr8iz410z935xw3";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 intltool xorg.libX11 xorg.libXres ];
  # ?another optional: startup-notification

  configureFlags = [ "--disable-introspection" ]; # not needed anywhere AFAIK

  meta = {
    description = "A library for creating task lists and pagers";
    homepage = "https://gitlab.gnome.org/GNOME/libwnck";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ johnazoidberg ];
  };
}
