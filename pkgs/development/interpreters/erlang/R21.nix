{ mkDerivation }:

mkDerivation rec {
  version = "21.3.8.3";
  sha256 = "1szybirrcpqsl2nmlmpbkxjqnm6i7l7bma87m5cpwi0kpvlxwmcw";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
  '';
}
