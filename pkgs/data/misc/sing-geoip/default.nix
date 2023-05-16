{ lib
, stdenvNoCC
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, dbip-country-lite
=======
, clash-geoip
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  generator = buildGoModule rec {
    pname = "sing-geoip";
<<<<<<< HEAD
    version = "20230512";
=======
    version = "unstable-2022-07-05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchFromGitHub {
      owner = "SagerNet";
      repo = pname;
<<<<<<< HEAD
      rev = "refs/tags/${version}";
      hash = "sha256-Zm+5N/37hoHpH/TLNJrHeaBXI8G1jEpM1jz6Um8edNE=";
    };

    vendorHash = "sha256-ejXAdsJwXhqet+Ca+pDLWwu0gex79VcIxW6rmhRnbTQ=";
=======
      rev = "2ced72c94da4c9259c40353c375319d9d28a78f3";
      hash = "sha256-z8aP+OfTuzQNwOT3EEnI9uze/vbHTJLEiCPqIrnNUHw=";
    };

    vendorHash = "sha256-lr0XMLFxJmLqIqCuGgmsFh324jmZVj71blmStMn41Rs=";

    postPatch = ''
      # The codes args should start from the third args
      substituteInPlace main.go --replace "os.Args[2:]" "os.Args[3:]"
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
  inherit (dbip-country-lite) version;
=======
  inherit (clash-geoip) version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontUnpack = true;

  nativeBuildInputs = [ generator ];

  buildPhase = ''
    runHook preBuild

<<<<<<< HEAD
    ${pname} ${dbip-country-lite.mmdb} geoip.db
    ${pname} ${dbip-country-lite.mmdb} geoip-cn.db cn
=======
    ${pname} ${clash-geoip}/etc/clash/Country.mmdb geoip.db
    ${pname} ${clash-geoip}/etc/clash/Country.mmdb geoip-cn.db cn
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    inherit (dbip-country-lite.meta) license;
=======
    inherit (clash-geoip.meta) license;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
