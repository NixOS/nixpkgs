{ lib
, buildGo120Module
, fetchFromGitHub
, substituteAll
, v2ray-domain-list-community
}:

let
  patch = substituteAll {
    src = ./main.go;
    geosite_data = "${v2ray-domain-list-community}/share/v2ray/geosite.dat";
  };
in
buildGo120Module {
  pname = "sing-geosite";
  inherit (v2ray-domain-list-community) version;

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-geosite";
    rev = "4a32d56c1705f77668beb5828df0b0a051efdeb9";
    hash = "sha256-P/EBcwJI2G9327BNi84R+q6BABx9DEKpN6ETTp8Q4NU=";
  };

  vendorHash = "sha256-uQOmUXT2wd40DwwTCMnFFKd47eu+BPBDjiCGtUNFoKY=";

  patchPhase = ''
    sed -i -e '/func main()/,/^}/d' -e '/"io"/a "io/ioutil"' main.go
    cat ${patch} >> main.go
  '';

  buildPhase = ''
    runHook preBuild
    go run -v .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 geosite.db $out/share/sing-box/geosite.db
    runHook postInstall
  '';

  meta = with lib; {
    description = "community managed domain list";
    homepage = "https://github.com/SagerNet/sing-geosite";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ linsui ];
  };
}
