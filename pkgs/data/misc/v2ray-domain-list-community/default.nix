{ stdenv, pkgsBuildBuild, fetchFromGitHub, lib }:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-domain-list-community";
    version = "20211119143108";
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
      sha256 = "sha256-CJMINkutaUI/Eka0OJTjeG3weTMYaNKdB2BWOxFgI3s=";
    };
    vendorSha256 = "sha256-JuLU9v1ukVfAEtz07tGk66st1+sO4SBz83BlK3IPQwU=";
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
    ${generator}/bin/domain-list-community -datapath $src/data --exportlists=category-ads-all,tld-cn,cn,tld-\!cn,geolocation-\!cn,apple,icloud
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm644 dlc.dat $out/share/v2ray/geosite.dat
    runHook postInstall
  '';
  passthru.generator = generator;
}
