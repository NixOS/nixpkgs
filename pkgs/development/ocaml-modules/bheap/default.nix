{ lib, buildDunePackage, fetchurl, stdlib-shims }:

buildDunePackage rec {
  pname = "bheap";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/backtracking/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "0dpnpla20lgiicrxl2432m2fcr6y68msw3pnjxqb11xw6yrdfhsz";
  };

  useDune2 = true;

  doCheck = true;
  nativeCheckInputs = [
    stdlib-shims
  ];

  meta = with lib; {
    description = "OCaml binary heap implementation by Jean-Christophe Filliatre";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/backtracking/bheap";
  };
}
