{
  coq,
  rocqPackages,
  mkCoqDerivation,
  lib,
  version ? null,
}@args:
(mkCoqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "coq";
  opam-name = "coq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      { case = isEq "9.0"; out = "9.0+rc1"; }
      { case = isLt "8.21"; out = "8.20"; }
    ] null;
  releaseRev = v: "V${v}";

  release."9.0+rc1".sha256 = "sha256-raHwniQdpAX1HGlMofM8zVeXcmlUs+VJZZg5VF43k/M=";
  release."8.20".sha256 = "sha256-AcoS4edUYCfJME1wx8UbuSQRF3jmxhArcZyPIoXcfu0=";

  useDune = true;

  installPhase = ''
    echo installing nothing
  '';

  meta = {
    description = "Compatibility metapackage for Coq Stdlib library after the Rocq renaming";
    license = lib.licenses.lgpl21Only;
  };

}).overrideAttrs
  (
    o:
    # stdlib is already included in Coq <= 8.20
    if coq.version != null && coq.version != "dev" && lib.versions.isLt "8.21" coq.version then {
      configurePhase = ''
        echo no configuration
      '';
      buildPhase = ''
        echo building nothing
      '';
      installPhase = ''
        touch $out
      '';
    } else { propagatedBuildInputs = [ rocqPackages.stdlib ]; }
  )
