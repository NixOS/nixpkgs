{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pkgsBuildBuild,
  jq,
  moreutils,
  dbip-country-lite,
}:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-geoip";
    version = "202501160051";

    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "geoip";
      tag = version;
      hash = "sha256-WSi7xsjKqQT37lzkOY1WZwvx5RXNKO3aMwnMiMBwMdA=";
    };

    vendorHash = "sha256-nvJsifXF6u3eWqd9X0kGZxASEs/LX2dQraZAwgnw060=";

    meta = {
      description = "GeoIP for V2Ray";
      homepage = "https://github.com/v2fly/geoip";
      license = lib.licenses.cc-by-sa-40;
      maintainers = with lib.maintainers; [ nickcao ];
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

    install -Dm444 -t "$out/share/v2ray" output/{cn,geoip-only-cn-private,geoip,private}.dat

    runHook postInstall
  '';

  passthru.generator = generator;

  meta = generator.meta // {
    inherit (dbip-country-lite.meta) license;
  };
}
