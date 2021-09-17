{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "2.7.2";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "29c68c5001a727aaa7a6842d6204ffa3e24b3544fa4f6af2234cdbfa032f7fdf";
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
