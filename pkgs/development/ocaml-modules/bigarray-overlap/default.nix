{ lib, buildDunePackage, ocaml, fetchurl
, bigarray-compat, alcotest, astring, fpath, bos, findlib, pkg-config
}:

buildDunePackage rec {
  pname = "bigarray-overlap";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/overlap/releases/download/v${version}/bigarray-overlap-v${version}.tbz";
    sha256 = "1v86avafsbyxjccy0y9gny31s2jzb0kd42v3mhcalklx5f044lcy";
  };

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  propagatedBuildInputs = [ bigarray-compat ];

  nativeBuildInputs = [ findlib pkg-config ];
  checkInputs = [ alcotest astring fpath bos ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/dinosaure/overlap";
    description = "A minimal library to know that 2 bigarray share physically the same memory or not";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
