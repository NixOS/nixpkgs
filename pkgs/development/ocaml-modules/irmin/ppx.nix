{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "1b6lav5br1b83cwdc3gj9mqkzhlbfjrbyjx0107zvj54m82dbrxb";
  };

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
  ];

  # tests depend on irmin, would create mutual dependency
  doCheck = false;

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
