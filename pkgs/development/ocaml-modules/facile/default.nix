{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "facile";
  version = "1.1.4";

  useDune2 = false;

  src = fetchurl {
    url = "https://github.com/Emmanuel-PLF/facile/releases/download/${version}/facile-${version}.tbz";
    sha256 = "0jqrwmn6fr2vj2rrbllwxq4cmxykv7zh0y4vnngx29f5084a04jp";
  };

  doCheck = true;

  meta = {
    homepage = "http://opti.recherche.enac.fr/facile/";
    license = lib.licenses.lgpl21Plus;
    description = "A Functional Constraint Library";
  };
}
