{ lib
, stdenvNoCC
, fetchFromGitHub
, pkgsBuildBuild
, jq
, moreutils
, dbip-country-lite
}:

let
  generator = pkgsBuildBuild.buildGoModule {
    pname = "v2ray-geoip";
    version = "unstable-2023-03-27";

    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "geoip";
      rev = "9321a7f5e301a957228eba44845144b4555b6658";
      hash = "sha256-S30XEgzA9Vrq7I7REfO/WN/PKpcjcI7KZnrL4uw/Chs=";
    };

    vendorHash = "sha256-bAXeA1pDIUuEvzTLydUIX6S6fm6j7CUQmBG+7xvxUcc=";

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
