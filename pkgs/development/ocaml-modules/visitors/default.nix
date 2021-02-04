{ lib, buildDunePackage, fetchFromGitLab, ppxlib, ppx_deriving, result }:

buildDunePackage rec {
  pname = "visitors";
  version = "20210127";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchFromGitLab {
    owner = "fpottier";
    repo = pname;
    rev = version;
    domain = "gitlab.inria.fr";
    sha256 = "0b73h7d4yv04a0b5x2i222jknbcgf9vvxzfjxzy2jwanxz9d873z";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving result ];

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/visitors";
    license = licenses.lgpl21;
    description = "An OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    maintainers = [ maintainers.marsam ];
  };
}
