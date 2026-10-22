{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pkgsBuildBuild,
  dbip-country-lite,
}:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-geoip";
    version = "202501190004";

    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "geoip";
      tag = version;
      hash = "sha256-l5gz3w/80o2UwexzcJ1ALhQMcwqor9m/0RG3WOBeVAc=";
    };

    vendorHash = "sha256-nvJsifXF6u3eWqd9X0kGZxASEs/LX2dQraZAwgnw060=";

    meta = {
      description = "GeoIP for V2Ray";
      homepage = "https://github.com/v2fly/geoip";
      license = lib.licenses.cc-by-sa-40;
      maintainers = with lib.maintainers; [ nickcao ];
    };
  };
in

stdenvNoCC.mkDerivation {
  inherit (generator) pname src;
  inherit (dbip-country-lite) version;

  nativeBuildInputs = [ generator ];

  buildPhase = ''
    runHook preBuild

    mkdir -p db-ip
    ln -s ${dbip-country-lite.mmdb} ./db-ip/dbip-country-lite.mmdb
    geoip

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
