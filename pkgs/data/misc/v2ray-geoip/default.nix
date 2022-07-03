{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202206230045";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "2e2aba7f3dfb4139e8a882f85350045f2ef522d1";
    sha256 = "sha256-WFvS51RmkAWivYj0HFAT6S3euJk+GSYLDTN3cmkcCNs=";
  };

  installPhase = ''
    runHook preInstall
    install -m 0644 geoip.dat -D $out/share/v2ray/geoip.dat
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "GeoIP for V2Ray";
    homepage = "https://github.com/v2fly/geoip";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ nickcao ];
  };
}
