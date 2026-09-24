{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "zscaler-cacert";

  # check it on the DHL keyserver homepage ('validity period')
  # and using openssl:
  # openssl x509 -startdate -noout -in ZscalerRootCertificate-2048-SHA256.crt

  version = "0-unstable-2025-02-02";

  src = fetchurl {
    url = "https://keyserver.dhl.com/pki/X3/ZscalerRootCertificate-2048-SHA256.crt";
    hash = "sha256-HrQ7am1IteSP1O3mz3weay1NQG8aj3EUt1ZjYRbOEQA=";
  };

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    install -Dm644 $src $out/etc/ssl/certs/zscaler-ca.crt
  '';

  meta = {
    description = "ZScaler Root CA certificate";
    homepage = "https://keyserver.dhl.com/certificates";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ aiyion ];
    platforms = lib.platforms.all;
  };
}
