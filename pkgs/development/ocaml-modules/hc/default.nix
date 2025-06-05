{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "hc";
  version = "0.5";

  # upstream git server is misconfigured and cannot be cloned
  src = fetchurl {
    url = "https://git.zapashcanon.fr/zapashcanon/hc/archive/${version}.tar.gz";
    hash = "sha256-xGPScoIMwGwWnep3XRADkpHK+w0b/g1nJI5lgY5K6Xg=";
  };

  doCheck = true;

  meta = {
    description = "Library for hash consing";
    homepage = "https://ocaml.org/p/hc/";
    downloadPage = "https://git.zapashcanon.fr/zapashcanon/hc";
    changelog = "https://git.zapashcanon.fr/zapashcanon/hc/src/tag/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
