{ stdenv, fetchurl, pkgconfig, gobject-introspection, intltool, vala
, libcap_ng, libvirt, libxml2
}:

stdenv.mkDerivation rec {
  name = "libvirt-glib-3.0.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://libvirt.org/sources/glib/${name}.tar.gz";
    sha256 = "1zpbv4ninc57c9rw4zmmkvvqn7154iv1qfr20kyxn8xplalqrzvz";
  };

  nativeBuildInputs = [ pkgconfig intltool vala gobject-introspection ];
  buildInputs = [ libcap_ng libvirt libxml2 gobject-introspection ];

  enableParallelBuilding = true;
  strictDeps = true;

  meta = with stdenv.lib; {
    description = "Library for working with virtual machines";
    longDescription = ''
      libvirt-glib wraps libvirt to provide a high-level object-oriented API better
      suited for glib-based applications, via three libraries:

      - libvirt-glib    - GLib main loop integration & misc helper APIs
      - libvirt-gconfig - GObjects for manipulating libvirt XML documents
      - libvirt-gobject - GObjects for managing libvirt objects
    '';
    homepage = https://libvirt.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
