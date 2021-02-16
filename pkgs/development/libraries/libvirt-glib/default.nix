{ lib, stdenv, fetchurl, pkg-config, gobject-introspection, intltool, vala
, libcap_ng, libvirt, libxml2
}:

stdenv.mkDerivation rec {
  name = "libvirt-glib-3.0.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://libvirt.org/sources/glib/${name}.tar.gz";
    sha256 = "1zpbv4ninc57c9rw4zmmkvvqn7154iv1qfr20kyxn8xplalqrzvz";
  };

  # https://bugzilla.redhat.com/show_bug.cgi?id=1304981
  patches = [ ./rm-version-script-linker-flag.patch ];

  nativeBuildInputs = [ pkg-config intltool vala gobject-introspection ];
  buildInputs = [ libvirt libxml2 gobject-introspection ]
    ++ lib.optional (!stdenv.isDarwin) [ libcap_ng  ];

  enableParallelBuilding = true;
  strictDeps = true;

  meta = with lib; {
    description = "Library for working with virtual machines";
    longDescription = ''
      libvirt-glib wraps libvirt to provide a high-level object-oriented API better
      suited for glib-based applications, via three libraries:

      - libvirt-glib    - GLib main loop integration & misc helper APIs
      - libvirt-gconfig - GObjects for manipulating libvirt XML documents
      - libvirt-gobject - GObjects for managing libvirt objects
    '';
    homepage = "https://libvirt.org/";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
