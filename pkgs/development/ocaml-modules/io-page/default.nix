{ lib, fetchurl, buildDunePackage, cstruct, bigarray-compat, ounit }:

buildDunePackage rec {
  pname = "io-page";
  version = "3.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "sha256-DjbKdNkFa6YQgJDLmLsuvyrweb4/TNvqAiggcj/3hu4=";
  };

  propagatedBuildInputs = [ cstruct bigarray-compat ];
  nativeCheckInputs = [ ounit ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/io-page";
    license = lib.licenses.isc;
    description = "IO memory page library for Mirage backends";
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
