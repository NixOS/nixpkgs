{ lib
, stdenvNoCC
, fetchurl
, geoip-db-tool
, mmdbctl
, python3
}:

stdenvNoCC.mkDerivation {
  pname = "ipfire-location-database";
  version = "2023-06-03";

  src = fetchurl {
    url = "https://git.ipfire.org/?p=location/location-database.git;a=blob_plain;f=database.txt;hb=ebaec2fbbbe7907a0a618f1548ca96ca7264741f";
    hash = "sha256-NAhxcXPu4GAgO3x62trtyKKAjD3ITGXOePx8fnwHUkc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    geoip-db-tool
    mmdbctl
    python3
  ];

  buildPhase = ''
    runHook preBuild

    geoip-db-tool -i $src
    python3 ${./csv-convertor.py} geoip geoip.csv
    sed -n '/^#/!p' geoip6 >> geoip.csv
    mmdbctl import -c geoip.csv geoip.mmdb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 geoip $out/share/tor/geoip
    install -Dm644 geoip6 $out/share/tor/geoip6
    install -Dm644 geoip.csv $out/share/ipfire/geoip.csv
    install -Dm644 geoip.mmdb $out/share/ipfire/geoip.mmdb

    runHook postInstall
  '';

  meta = with lib; {
    description = "IPFire Location database";
    homepage = "https://location.ipfire.org/";
    license = with licenses; [ cc-by-sa-40 ];
    maintainers = with maintainers; [ linsui ];
    platforms = platforms.all;
  };
}

