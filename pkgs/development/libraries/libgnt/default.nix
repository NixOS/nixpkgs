{ stdenv, lib, fetchurl, meson, ninja, pkgconfig, python2
, gtk-doc, docbook-xsl-nons
, glib, ncurses, libxml2
}:
let
  # Pidgin will get build-time dependency on gtk-doc anyway (through gstreamer).
  docs = true;
in
stdenv.mkDerivation rec {
  pname = "libgnt";
  version = "2.14.0";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${pname}-${version}.tar.xz";
    sha256 = "6b7ea2030c9755ad9756ab4b1d3396dccaef4a712eccce34d3990042bb4b3abf";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "ncurses_sys_prefix = '/usr'" \
      "ncurses_sys_prefix = '${lib.getDev ncurses}'"
  ''
  + lib.optionalString (!docs) ''
    sed "/^subdir('doc')$/d" -i meson.build
  '';

  outputs = [ "out" "dev" ] ++ lib.optional docs "devdoc";

  nativeBuildInputs = [ meson ninja pkgconfig ]
    ++ lib.optionals docs [ gtk-doc docbook-xsl-nons ];

  # python2 is optional but Pidgin does depend on it (and python3 won't be accepted in 2.x)
  buildInputs = [ glib ncurses libxml2 python2 ];

  meta = with stdenv.lib; {
    description = "An ncurses toolkit for creating text-mode graphical user interfaces";
    homepage = "https://keep.imfreedom.org/libgnt/libgnt/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}

