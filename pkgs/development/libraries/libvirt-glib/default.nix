{ stdenv, fetchurl, pkgconfig, libvirt, glib, libxml2, intltool, libtool, yajl
, nettle, libgcrypt, pythonPackages, gobjectIntrospection, libcap_ng, numactl
, xen, libapparmor, vala
}:

let
  inherit (pythonPackages) python pygobject2;
in stdenv.mkDerivation rec {
  name = "libvirt-glib-1.0.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "http://libvirt.org/sources/glib/${name}.tar.gz";
    sha256 = "0iwa5sdbii52pjpdm5j37f67sdmf0kpcky4liwhy1nf43k85i4fa";
  };

  nativeBuildInputs = [ pkgconfig vala ];
  buildInputs = [
    libvirt glib libxml2 intltool libtool yajl nettle libgcrypt
    python pygobject2 gobjectIntrospection libcap_ng numactl libapparmor
  ] ++ stdenv.lib.optionals stdenv.isx86_64 [
    xen
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for working with virtual machines";
    longDescription = ''
      libvirt-glib wraps libvirt to provide a high-level object-oriented API better
      suited for glib-based applications, via three libraries:

      - libvirt-glib    - GLib main loop integration & misc helper APIs
      - libvirt-gconfig - GObjects for manipulating libvirt XML documents
      - libvirt-gobject - GObjects for managing libvirt objects
    '';
    homepage = http://libvirt.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
