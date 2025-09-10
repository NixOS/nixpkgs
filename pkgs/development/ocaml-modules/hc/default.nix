{
  lib,
  buildDunePackage,
  fetchzip,
}:

buildDunePackage rec {
  pname = "hc";
  version = "0.5";

  minimalOCamlVersion = "4.12";

  # upstream git server is misconfigured and cannot be cloned
  src = fetchzip {
    url = "https://git.zapashcanon.fr/zapashcanon/hc/archive/${version}.tar.gz";
    hash = "sha256-oTomFi+e9aCgVpZ9EkxQ/dZz18cW2UcaV0ZIokeBoU0=";
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
