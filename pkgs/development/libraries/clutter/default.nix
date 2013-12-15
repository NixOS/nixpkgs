{ stdenv, fetchurl, glib, pkgconfig, mesa, libX11, libXext, libXfixes
, libXdamage, libXcomposite, libXi, cogl, pango, atk, json_glib, 
gobjectIntrospection 
}:

stdenv.mkDerivation {
  name = "clutter-1.8.2";

  src = fetchurl {
    url = mirror://gnome/sources/clutter/1.8/clutter-1.8.2.tar.xz;
    sha256 = "0bzsvnharawfg525lpavrp55mq4aih5nb01dwwqwnccg8hk9z2fw";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs =
    [ libX11 mesa libXext libXfixes libXdamage libXcomposite libXi cogl pango
      atk json_glib gobjectIntrospection
    ];

  configureFlags = [ "--enable-introspection" ]; # needed by muffin AFAIK

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
    homepage = http://www.clutter-project.org/;

    maintainers = with stdenv.lib.maintainers; [ urkud ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
