{ lib
, stdenvNoCC
, buildGoModule
, fetchFromGitHub
, clash-geoip
}:

let
  generator = buildGoModule rec {
    pname = "sing-geoip";
    version = "unstable-2022-07-05";

    src = fetchFromGitHub {
      owner = "SagerNet";
      repo = pname;
      rev = "2ced72c94da4c9259c40353c375319d9d28a78f3";
      hash = "sha256-z8aP+OfTuzQNwOT3EEnI9uze/vbHTJLEiCPqIrnNUHw=";
    };

    vendorHash = "sha256-lr0XMLFxJmLqIqCuGgmsFh324jmZVj71blmStMn41Rs=";

    postPatch = ''
      # The codes args should start from the third args
      substituteInPlace main.go --replace "os.Args[2:]" "os.Args[3:]"
    '';

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
  inherit (clash-geoip) version;

  dontUnpack = true;

  nativeBuildInputs = [ generator ];

  buildPhase = ''
    runHook preBuild

    ${pname} ${clash-geoip}/etc/clash/Country.mmdb geoip.db
    ${pname} ${clash-geoip}/etc/clash/Country.mmdb geoip-cn.db cn

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
    inherit (clash-geoip.meta) license;
  };
}
