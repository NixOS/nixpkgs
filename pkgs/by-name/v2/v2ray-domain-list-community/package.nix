{
  stdenv,
  pkgsBuildBuild,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-domain-list-community";
    version = "20260129053508";
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
      hash = "sha256-Nm9LmAgJQwlRit2oreWyTymbu1PZjTpu2LH5twU0X6o=";
    };
    vendorHash = "sha256-9tXv+rDBowxDN9gH4zHCr4TRbic4kijco3Y6bojJKRk=";
    meta = {
      description = "Community managed domain list";
      homepage = "https://github.com/v2fly/domain-list-community";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ nickcao ];
    };
  };
in
stdenv.mkDerivation {
  inherit (generator)
    pname
    version
    src
    meta
    ;
  buildPhase = ''
    runHook preBuild
    ${generator}/bin/domain-list-community -datapath $src/data
    ${generator}/bin/datdump --inputdata=dlc.dat --exportlists=_all_
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm644 dlc.dat           $out/share/v2ray/geosite.dat
    install -Dm644 dlc.dat_plain.yml $out/share/v2ray/geosite.dat_plain.yml
    runHook postInstall
  '';
  passthru = {
    inherit generator;
    updateScript = nix-update-script { };
  };
}
