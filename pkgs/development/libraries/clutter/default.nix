{ fetchurl, stdenv, pkgconfig, mesa, libXi, libXfixes, libXdamage
, libXcomposite, cairo, glib, pango, gtk }:

stdenv.mkDerivation rec {
  name = "clutter-1.2.10";

  src = fetchurl {
    url = "http://source.clutter-project.org/sources/clutter/1.2/${name}.tar.gz";
    sha256 = "0bdnj026lqmwpgml73q4r0v90gsksjz0nv2fgjda9619bzx47igi";
  };

  buildInputs = [ pkgconfig ];

  # There are all listed in the `Requires' field of `clutter-x11-1.0.pc'.
  propagatedBuildInputs =
    [ mesa cairo glib pango gtk
      libXi libXfixes libXdamage libXcomposite
    ];


  meta = {
    description = "Clutter, a library for creating fast, dynamic graphical user interfaces";

    longDescription =
      '' Clutter is free software library for creating fast, compelling,
         portable, and dynamic graphical user interfaces.  It is a core part
         of MeeGo, and is supported by the open source community.  Its
         development is sponsored by Intel.

         Clutter uses OpenGL for rendering (and optionally OpenGL|ES for use
         on mobile and embedded platforms), but wraps an easy to use,
         efficient, flexible API around GL's complexity.

         Clutter enforces no particular user interface style, but provides a
         rich, generic foundation for higher-level toolkits tailored to
         specific needs.
      '';

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
