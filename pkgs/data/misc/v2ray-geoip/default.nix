{ lib
, stdenvNoCC
, fetchFromGitHub
, pkgsBuildBuild
, jq
, moreutils
, dbip-country-lite
}:

let
  generator = pkgsBuildBuild.buildGo120Module {
    pname = "v2ray-geoip";
    version = "unstable-2023-10-11";

    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "geoip";
      rev = "3182dda7b38c900f28505b91a44b09ec486e6f36";
      hash = "sha256-KSRgof78jScwnUeMtryj34J0mBsM/x9hFE4H9WtZUuM=";
    };

    vendorHash = "sha256-rlRazevKnWy/Ig143s8TZgV3JlQMlHID9rnncLYhQDc=";

    meta = with lib; {
      description = "GeoIP for V2Ray";
      homepage = "https://github.com/v2fly/geoip";
      license = licenses.cc-by-sa-40;
      maintainers = with maintainers; [ nickcao ];
    };
  };
  input = {
    type = "maxmindMMDB";
    action = "add";
    args = {
      uri = dbip-country-lite.mmdb;
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit (generator) pname src;
  inherit (dbip-country-lite) version;

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postPatch = ''
    jq '.input[0] |= ${builtins.toJSON input}' config.json | sponge config.json
  '';

  buildPhase = ''
    runHook preBuild
    ${generator}/bin/geoip
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out/share/v2ray" output/dat/{cn,geoip-only-cn-private,geoip,private}.dat
    runHook postInstall
  '';

  passthru.generator = generator;

  meta = generator.meta // {
    inherit (dbip-country-lite.meta) license;
  };
}
