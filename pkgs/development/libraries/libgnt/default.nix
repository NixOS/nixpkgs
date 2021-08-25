{ stdenv, lib, fetchurl, meson, ninja, pkg-config
, gtk-doc, docbook-xsl-nons
, glib, ncurses, libxml2
, buildDocs ? true
}:
stdenv.mkDerivation rec {
  pname = "libgnt";
  version = "2.14.1";

  outputs = [ "out" "dev" ] ++ lib.optional buildDocs "devdoc";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${pname}-${version}.tar.xz";
    sha256 = "1n2bxg0ignn53c08cp69pj4sdg53kwlqn23rincyjmpr327fdhsy";
  };

  nativeBuildInputs = [ meson ninja pkg-config ]
    ++ lib.optionals buildDocs [ gtk-doc docbook-xsl-nons ];

  buildInputs = [ glib ncurses libxml2 ];

  postPatch = ''
    substituteInPlace meson.build --replace \
      "ncurses_sys_prefix = '/usr'" \
      "ncurses_sys_prefix = '${lib.getDev ncurses}'"
  '' + lib.optionalString (!buildDocs) ''
    sed "/^subdir('doc')$/d" -i meson.build
  '';

  meta = with lib; {
    description = "An ncurses toolkit for creating text-mode graphical user interfaces";
    homepage = "https://keep.imfreedom.org/libgnt/libgnt/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ ony ];
  };
}
