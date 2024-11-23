{ lib, fetchzip, buildDunePackage, ocaml }:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "nonstd is not available for OCaml ≥ 5.0"

buildDunePackage rec {
  pname = "nonstd";
  version = "0.0.3";

  minimalOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://bitbucket.org/smondet/${pname}/get/${pname}.${version}.tar.gz";
    sha256 = "0ccjwcriwm8fv29ij1cnbc9win054kb6pfga3ygzdbjpjb778j46";
  };

  duneVersion = if lib.versionAtLeast ocaml.version "4.12" then "2" else "1";
  postPatch = lib.optionalString (duneVersion != "1") "dune upgrade";
  doCheck = true;

  meta = with lib; {
    homepage = "https://bitbucket.org/smondet/nonstd";
    description = "Non-standard mini-library";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
