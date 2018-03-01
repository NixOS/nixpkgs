{ stdenv, fetchurl, glib, pkgconfig, mesa, libX11, libXext, libXfixes
, libXdamage, libXcomposite, libXi, libxcb, cogl, pango, atk, json-glib, 
gobjectIntrospection, gtk3
}:

let
  ver_maj = "1.26";
  ver_min = "2";
in
stdenv.mkDerivation rec {
  name = "clutter-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter/${ver_maj}/${name}.tar.xz";
    sha256 = "0mif1qnrpkgxi43h7pimim6w6zwywa16ixcliw0yjm9hk0a368z7";
  };

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs =
    [ libX11 mesa libXext libXfixes libXdamage libXcomposite libXi cogl pango
      atk json-glib gobjectIntrospection libxcb
    ];

  configureFlags = [ "--enable-introspection" ]; # needed by muffin AFAIK

  #doCheck = true; # no tests possible without a display

  meta = {
    description = "Library for creating fast, dynamic graphical user interfaces";

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

    license = stdenv.lib.licenses.lgpl2Plus;
    homepage = http://www.clutter-project.org/;

    maintainers = with stdenv.lib.maintainers; [ lethalman ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
