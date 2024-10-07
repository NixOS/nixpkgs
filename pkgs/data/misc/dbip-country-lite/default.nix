{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbip-country-lite";
  version = "2024-10";

  src = fetchurl {
    url = "https://download.db-ip.com/free/dbip-country-lite-${finalAttrs.version}.mmdb.gz";
    hash = "sha256-MeAhfDY2jdX2WDsNGNjvH/JeCo9C1hx3PWyk8am9Ut0=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preBuild

    gzip -c -d "$src" > dbip-country-lite.mmdb
    install -Dm444 dbip-country-lite.mmdb "$out/share/dbip/dbip-country-lite.mmdb"

    runHook postBuild
  '';

  passthru.mmdb = "${finalAttrs.finalPackage}/share/dbip/dbip-country-lite.mmdb";

  meta = with lib; {
    description = "Free IP to Country Lite database by DB-IP";
    homepage = "https://db-ip.com/db/download/ip-to-country-lite";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.all;
  };
})
