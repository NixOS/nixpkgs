{ back, base, gui, gsmakeDerivation, fetchurl }:
let
  version = "1.1.0";
in
gsmakeDerivation {
  name = "system_preferences-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/SystemPreferences-${version}.tar.gz";
    sha256 = "1q68bs8rlq0dxkar01qs5wfyas4iivddnama371jd7ll6cxzmpy7";
  };
#  GNUSTEP_MAKEFILES = "${gnustep_make}/share/GNUstep/Makefiles";
  buildInputs = [ back base gui ];
#  propagatedBuildInputs = [ gnustep_back gnustep_base gnustep_gui ];
  meta = {
    description = "System Preferences allows to manage the settings of many aspects of the GNUstep environment and its applications";
  };
}
