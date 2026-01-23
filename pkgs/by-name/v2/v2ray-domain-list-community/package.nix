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
    version = "20260122141558";
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
      hash = "sha256-MmtAA+SR8a6glzAuKaqH3z/cqKlYUQNRzymtPlOrbcg=";
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
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm644 dlc.dat $out/share/v2ray/geosite.dat
    runHook postInstall
  '';
  passthru = {
    inherit generator;
    updateScript = nix-update-script { };
  };
}
