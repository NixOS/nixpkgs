{ fetchurl
, base, back, gsmakeDerivation, gui, gorm
, gnumake, gdb
}:
let
  version = "0.6.2";
in
gsmakeDerivation {
  name = "projectcenter-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/ProjectCenter-${version}.tar.gz";
    sha256 = "0wwlbpqf541apw192jb633d634zkpjhcrrkd1j80y9hihphll465";
  };

  # NOTE: need a patch for ProjectCenter to help it locate some necessary tools:
  # 1. Framework/PCProjectLauncher.m, locate gdb (say among NIX_GNUSTEP_SYSTEM_TOOLS)
  # 2. Framework/PCProjectBuilder.m, locate gmake (similar)
  propagatedBuildInputs = [ base back gui gnumake gdb gorm ];
  
  meta = {
    description = "GNUstep's integrated development environment";
  };
}
