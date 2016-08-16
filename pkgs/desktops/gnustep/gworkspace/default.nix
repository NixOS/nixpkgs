{ back, base, gui, gsmakeDerivation
, fetchurl
, sqlite
, system_preferences
}:
let
  version = "0.9.3";
in
gsmakeDerivation {
  name = "gworkspace-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${version}.tar.gz";
    sha256 = "0jchqwb0dj522j98jqlqlib44jppax39zx2zqyzdwiz4qjl470r3";
  };
  # additional dependencies:
  # - PDFKit framework from http://gap.nongnu.org/
  # - TODO: to --enable-gwmetadata, need libDBKit as well as sqlite!
  buildInputs = [ back base gui system_preferences ];
  configureFlags = [ "--with-inotify" ];
  meta = {
    description = "A workspace manager for GNUstep";
  };
}
