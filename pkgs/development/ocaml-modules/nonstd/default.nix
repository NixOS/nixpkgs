{ lib, fetchzip, buildDunePackage, ocaml }:

buildDunePackage rec {
  pname = "nonstd";
  version = "0.0.3";

  minimalOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://bitbucket.org/smondet/${pname}/get/${pname}.${version}.tar.gz";
    sha256 = "0ccjwcriwm8fv29ij1cnbc9win054kb6pfga3ygzdbjpjb778j46";
  };

  useDune2 = lib.versionAtLeast ocaml.version "4.12";
  postPatch = lib.optionalString useDune2 "dune upgrade";
  doCheck = true;

  meta = with lib; {
    homepage = "https://bitbucket.org/smondet/nonstd";
    description = "Non-standard mini-library";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
