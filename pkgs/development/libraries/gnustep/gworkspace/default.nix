{ back, base, gui, gsmakeDerivation
, fetchurl
, sqlite
, stdenv
, system_preferences
}:
let
  version = "0.9.2";
in
gsmakeDerivation {
  name = "gworkspace-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${version}.tar.gz";
    sha256 = "1yzlka2dl1gb353wf9kw6l26sdihdhgwvdfg5waqwdfl7ycfyfaj";
  };
  # additional dependencies:
  # - PDFKit framework from http://gap.nongnu.org/
  # - TODO: to --enable-gwmetadata, need libDBKit as well as sqlite!
  buildInputs = [ back base gui system_preferences ];
#  propagatedBuildInputs = [ gnustep_back gnustep_base gnustep_gui system_preferences ];
  configureFlags = [ "--with-inotify" ];
  meta = {
    description = "GWorkspace is a workspace manager for GNUstep";

    homepage = http://www.gnustep.org/experience/GWorkspace.html;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.linux;
  };
}
