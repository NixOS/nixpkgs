{ lib
, stdenvNoCC
, buildGoModule
, fetchFromGitHub
, dbip-country-lite
}:

let
  generator = buildGoModule rec {
    pname = "sing-geoip";
    version = "20230512";

    src = fetchFromGitHub {
      owner = "SagerNet";
      repo = pname;
      rev = "refs/tags/${version}";
      hash = "sha256-Zm+5N/37hoHpH/TLNJrHeaBXI8G1jEpM1jz6Um8edNE=";
    };

    vendorHash = "sha256-ejXAdsJwXhqet+Ca+pDLWwu0gex79VcIxW6rmhRnbTQ=";

    meta = with lib; {
      description = "GeoIP data for sing-box";
      homepage = "https://github.com/SagerNet/sing-geoip";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ linsui ];
    };
  };
in
stdenvNoCC.mkDerivation rec {
  inherit (generator) pname;
  inherit (dbip-country-lite) version;

  dontUnpack = true;

  nativeBuildInputs = [ generator ];

  buildPhase = ''
    runHook preBuild

    ${pname} ${dbip-country-lite.mmdb} geoip.db
    ${pname} ${dbip-country-lite.mmdb} geoip-cn.db cn

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 geoip.db $out/share/sing-box/geoip.db
    install -Dm644 geoip-cn.db $out/share/sing-box/geoip-cn.db

    runHook postInstall
  '';

  passthru = { inherit generator; };

  meta = generator.meta // {
    inherit (dbip-country-lite.meta) license;
  };
}
