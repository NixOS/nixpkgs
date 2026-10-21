{
  lib,
  fetchurl,
  buildDunePackage,
  astring,
  asetmap,
  re,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "prometheus";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/mirage/prometheus/releases/download/v${finalAttrs.version}/prometheus-${finalAttrs.version}.tbz";
    hash = "sha256-4C0UzwaCgqtk5SGIY89rg0dxdrKm63lhdcOaQAa20L8=";
  };

  propagatedBuildInputs = [
    astring
    asetmap
    re
    lwt
  ];

  meta = {
    homepage = "https://github.com/mirage/prometheus";
    description = "Client library for Prometheus monitoring";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ulrikstrid ];
    changelog = "https://raw.githubusercontent.com/mirage/prometheus/v${finalAttrs.version}/CHANGES.md";
  };
})
