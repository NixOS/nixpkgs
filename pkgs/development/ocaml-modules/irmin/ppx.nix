{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "1db134221e82c424260a0e206b640fcb82902be35eea4137af2bcd9c98d3ac0f";
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
