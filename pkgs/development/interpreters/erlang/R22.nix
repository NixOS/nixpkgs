{ mkDerivation }:

mkDerivation {
  version = "22.1";
  sha256 = "0p0lwajq5skbhrx1nw8ncphj409rl6wghjrgk7d3libz12hnwrpn";

  prePatch = ''
    substituteInPlace make/configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
    substituteInPlace erts/configure.in --replace '-Wl,-no_weak_imports' ""
  '';
}
