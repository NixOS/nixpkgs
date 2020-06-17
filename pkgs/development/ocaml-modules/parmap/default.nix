{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/rdicosmo/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1pci7b1jqxkgmrbhr0p5j98i4van5nfmmb3sak8cyvxhwgna93j4";
  };

  doCheck = true;

  meta = with lib; {
    description = "Library for multicore parallel programming";
    homepage = "https://rdicosmo.github.io/parmap";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
