{
  lib,
  stdenv,
  fetchzip,
  autoreconfHook,
  pkg-config,
  libxml2,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlstarlet";
  version = "1.6.1";

  src = fetchzip {
    url = "mirror://sourceforge/xmlstar/xmlstarlet-${finalAttrs.version}.tar.gz";
    hash = "sha256-lJj9ON2ycLHKUm32rOYVJNyNNnogrWBqAJp0Y+twHVo=";
  };

  # libxml 2.14 and later stopped defining ATTRIBUTE_UNUSED macro in
  # the header file so it must be redefined here to avoid a
  # compilation error.
  # See: https://gitlab.gnome.org/GNOME/libxml2/-/commit/208f27f9641a59863ce1f7d4992df77f7eb0ea9d
  postPatch = ''
    sed -i '1s/^/\#define ATTRIBUTE_UNUSED __attribute__((unused))\n/' \
        src/xmlstar.h
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libxml2
    libxslt
  ];

  # Even though only the 'xml' binary is produced, many references
  # show 'xmlstarlet' as the binary name so it has to be matched here
  # for convenience sake.
  postInstall = ''
    ln -s $out/bin/xml $out/bin/xmlstarlet
  '';

  meta = {
    description = "Command line tool for manipulating and querying XML data";
    homepage = "https://xmlstar.sourceforge.net/";
    license = lib.licenses.mit;
    mainProgram = "xml";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ normalcea ];
  };
})
