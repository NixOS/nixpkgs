{ back, base, gui, gsmakeDerivation
, fetchurl
, system_preferences
}:
let
  version = "1.0.0";
in
gsmakeDerivation {
  name = "gworkspace-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${version}.tar.gz";
    sha256 = "sha256-M7dV7RVatw8gdYHQlRi5wNBd6MGT9GqW04R/DoKNu6I=";
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
