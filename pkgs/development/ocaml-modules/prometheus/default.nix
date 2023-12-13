{ lib, fetchurl, buildDunePackage, astring, asetmap, fmt, re, lwt, alcotest }:

buildDunePackage rec {
  pname = "prometheus";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/mirage/prometheus/releases/download/v${version}/prometheus-${version}.tbz";
    sha256 = "sha256-g2Q6ApprbecdFANO7i6U/v8dCHVcSkHVg9wVMKtVW8s=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [
    astring
    asetmap
    fmt
    re
    lwt
    alcotest
  ];

  meta = {
    description = "Client library for Prometheus monitoring";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
