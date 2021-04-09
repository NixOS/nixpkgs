{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "2.5.2";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "ac8d75144cafdaf4b5e106b540a27338245510b7e33a8c412d393c9d50cae490";
  };

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
  ];

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl sternenseemann ];
  };
}
