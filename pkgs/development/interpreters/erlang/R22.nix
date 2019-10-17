{ mkDerivation }:

mkDerivation {
  version = "22.1.3";
  sha256 = "02n7x208frbym63m1lpm3hscq6464gbmzqmf910m6fjpsyrxm8s2";

  prePatch = ''
    substituteInPlace make/configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
    substituteInPlace erts/configure.in --replace '-Wl,-no_weak_imports' ""
  '';
}
