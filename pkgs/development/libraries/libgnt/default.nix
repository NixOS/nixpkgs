{ stdenv, lib, fetchurl, meson, ninja, pkg-config
, gtk-doc, docbook-xsl-nons
, glib, ncurses, libxml2
, buildDocs ? true
, mesonEmulatorHook
}:
stdenv.mkDerivation rec {
  pname = "libgnt";
  version = "2.14.3";

  outputs = [ "out" "dev" ] ++ lib.optional buildDocs "devdoc";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${pname}-${version}.tar.xz";
    hash = "sha256-V/VFf3KZnQuxoTmjfydG7BtaAsCU8nEKM52LzqQjYSM=";
  };

  nativeBuildInputs = [ glib meson ninja pkg-config ]
    ++ lib.optionals buildDocs [ gtk-doc docbook-xsl-nons ]
    ++ lib.optionals (buildDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs = [ glib ncurses libxml2 ];

  postPatch = ''
    substituteInPlace meson.build --replace \
      "ncurses_sys_prefix = '/usr'" \
      "ncurses_sys_prefix = '${lib.getDev ncurses}'"
  '';
  mesonFlags = [
    (lib.mesonBool "doc" buildDocs)
    (lib.mesonBool "python2" false)
  ];

  meta = with lib; {
    description = "Ncurses toolkit for creating text-mode graphical user interfaces";
    homepage = "https://keep.imfreedom.org/libgnt/libgnt/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ ony ];
  };
}
