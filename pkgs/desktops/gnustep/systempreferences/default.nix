{ back, base, gui, gsmakeDerivation, fetchurl }:
let
  version = "1.2.0";
in
gsmakeDerivation {
  name = "system_preferences-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/SystemPreferences-${version}.tar.gz";
    sha256 = "1fg7c3ihfgvl6n21rd17fs9ivx3l8ps874m80vz86n1callgs339";
  };
#  GNUSTEP_MAKEFILES = "${gnustep_make}/share/GNUstep/Makefiles";
  buildInputs = [ back base gui ];
#  propagatedBuildInputs = [ gnustep_back gnustep_base gnustep_gui ];
  meta = {
    description = "The settings manager for the GNUstep environment and its applications";
  };
}
