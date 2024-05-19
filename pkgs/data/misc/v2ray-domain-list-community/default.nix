{ stdenv, pkgsBuildBuild, fetchFromGitHub, lib, nix-update-script }:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-domain-list-community";
    version = "20240508170917";
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
      hash = "sha256-fxiKd4bnEqUsqiBkU6EiMe8dd1uaopqU52CgclDFiuI=";
    };
    vendorHash = "sha256-NLh14rXRci4hgDkBJVJDIDvobndB7KYRKAX7UjyqSsg=";
    meta = with lib; {
      description = "community managed domain list";
      homepage = "https://github.com/v2fly/domain-list-community";
      license = licenses.mit;
      maintainers = with maintainers; [ nickcao ];
    };
  };
in
stdenv.mkDerivation {
  inherit (generator) pname version src meta;
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
