{ lib, fetchFromGitHub
, base, back, gsmakeDerivation, gui, gorm
, gnumake, gdb
}:
let
  version = "0.7.0";
in
gsmakeDerivation {
  pname = "projectcenter";
  inherit version;

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "apps-projectcenter";
    rev = "projectcenter-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-uXT2UUvMZNc6Fqi2BUXQimbZk8b3IqXzB+A2btBOmms=";
  };

  # NOTE: need a patch for ProjectCenter to help it locate some necessary tools:
  # 1. Framework/PCProjectLauncher.m, locate gdb (say among NIX_GNUSTEP_SYSTEM_TOOLS)
  # 2. Framework/PCProjectBuilder.m, locate gmake (similar)
  propagatedBuildInputs = [ base back gui gnumake gdb gorm ];

  meta = {
    description = "GNUstep's integrated development environment";
  };
}
