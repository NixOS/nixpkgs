{
  lib,
  fetchurl,
  buildDunePackage,
  astring,
  asetmap,
<<<<<<< HEAD
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
=======
  fmt,
  re,
  lwt,
  alcotest,
}:

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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
