{ stdenv, fetchurl
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
    description = "ProjectCenter is GNUstep's integrated development environment (IDE) and allows a rapid development and easy managment of ProjectCenter running on GNUstep applications, tools and frameworks.";

    homepage = http://www.gnustep.org/experience/ProjectCenter.html;

    license = stdenv.lib.licenses.lgpl2Plus;
  
    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.linux;
  };
}
