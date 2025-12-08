{
  lib,
  fetchurl,
  buildDunePackage,
  astring,
  asetmap,
  fmt,
  re,
  lwt,
  alcotest,
}:

buildDunePackage rec {
  pname = "prometheus";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/mirage/prometheus/releases/download/v${version}/prometheus-${version}.tbz";
    sha256 = "sha256-4C0UzwaCgqtk5SGIY89rg0dxdrKm63lhdcOaQAa20L8=";
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
