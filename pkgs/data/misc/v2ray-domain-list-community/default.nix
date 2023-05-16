{ stdenv, pkgsBuildBuild, fetchFromGitHub, lib }:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-domain-list-community";
<<<<<<< HEAD
    version = "20230905081311";
=======
    version = "20230407083123";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
<<<<<<< HEAD
      hash = "sha256-lSiEfLfXnxou0pt9k6SFRnCm/CeUh2TBhLzi6BwJs7w=";
    };
    vendorHash = "sha256-dYaGR5ZBORANKAYuPAi9i+KQn2OAGDGTZxdyVjkcVi8=";
=======
      hash = "sha256-+TOZR8ty4BqjPpzKZtqzfgduRSf4PiHoUUx0eMkV0mk=";
    };
    vendorHash = "sha256-zkf2neI1HiPkCrcw+cYoZ2L/OGkM8HPIv5gUqc05Wak=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
