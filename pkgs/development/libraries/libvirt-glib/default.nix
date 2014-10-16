{ stdenv, fetchurl, pkgconfig, libvirt, glib, libxml2, intltool, libtool, yajl
, nettle, libgcrypt, python, pygobject, gobjectIntrospection, libcap_ng
}:

stdenv.mkDerivation rec {
  name = "libvirt-glib-0.1.9";

  src = fetchurl {
    url = "http://libvirt.org/sources/glib/${name}.tar.gz";
    sha256 = "0n59hp0kwn80z9136g2n7pwkrlhlsxksr6gy4w7783d71qk3cfq5";
  };

  buildInputs = [
    pkgconfig libvirt glib libxml2 intltool libtool yajl nettle libgcrypt
    python pygobject gobjectIntrospection libcap_ng
  ];

  # Compiler flag -fstack-protector-all fixes this build error:
  #
  #   ./.libs/libvirt-glib-1.0.so: undefined reference to `__stack_chk_guard'
  #
  # And the extra include path fixes this build error:
  #
  #   In file included from ../libvirt-gobject/libvirt-gobject-domain-device.h:30:0,
  #                    from /tmp/nix-build-libvirt-glib-0.1.7.drv-2/libvirt-glib-0.1.7/libvirt-gobject/libvirt-gobject.h:33,
  #                    from <stdin>:4:
  #   ../libvirt-gobject/libvirt-gobject-domain.h:33:29: fatal error: libvirt/libvirt.h: No such file or directory
  #   compilation terminated.
  #   make[3]: *** [LibvirtGObject-1.0.gir] Error 1
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-fstack-protector-all -I${libvirt}/include"
  '';

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
