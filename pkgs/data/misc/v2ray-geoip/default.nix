{ lib
, stdenvNoCC
, fetchpatch
, fetchFromGitHub
, pkgsBuildBuild
, jq
, moreutils
, dbip-country-lite
}:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-geoip";
    version = "202403140037";

    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "geoip";
      rev = version;
      hash = "sha256-nqobjgeDvD5RYvCVVd14XC/tb/+SVfvdQUFZ3gfeDrI=";
    };

    vendorHash = "sha256-cuKcrYAzjIt6Z4wYg5R6JeL413NDwTub2fZndXEKdTo=";

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
