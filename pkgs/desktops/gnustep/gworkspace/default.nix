{ back, base, gui, gsmakeDerivation
, fetchurl
, sqlite
, system_preferences
}:
let
  version = "0.9.4";
in
gsmakeDerivation {
  name = "gworkspace-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${version}.tar.gz";
    sha256 = "0cjn83m7qmbwdpldlyhs239nwswgip3yaz01ahls130dq5qq7hgk";
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
