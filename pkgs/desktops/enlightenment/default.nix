{ stdenv, fetchurl, pkgconfig, x11, xlibs, dbus, imlib2, freetype }:

let version = "0.16.8.15"; in
  stdenv.mkDerivation {
    name = "enlightenment-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/enlightenment/e16-${version}.tar.gz";
      sha256 = "0f8hg79mrk6b3fsvynvsrnqh1zgmvnnza0lf7qn4pq2mqyigbhgk";
    };

    buildInputs = [pkgconfig imlib2 freetype 
      xlibs.libX11 xlibs.libXt xlibs.libXext xlibs.libXrender xlibs.libXft ];

    meta = {
      description = "Desktop shell built on the Enlightenment Foundation Libraries";

      longDescription = ''
        Enlightenment is a window manager.  Enlightenment is a desktop
        shell.  Enlightenment is the building blocks to create
        beautiful applications.  Enlightenment, or simply e, is a
        group of people trying to make a new generation of software.
      '';

      homepage = http://enlightenment.org/;

      license = "BSD-style";
    };
  }
