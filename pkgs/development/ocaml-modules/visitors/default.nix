{ lib, buildDunePackage, fetchFromGitLab, ppx_tools, ppx_deriving, result, cppo }:

buildDunePackage rec {
  pname = "visitors";
  version = "20200210";

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";

  src = fetchFromGitLab {
    owner = "fpottier";
    repo = pname;
    rev = version;
    domain = "gitlab.inria.fr";
    sha256 = "12i099h1hc1walabiwqbinnpgcxkc1wn72913v7v6vvyif21rb5a";
  };

  buildInputs = [ cppo ];

  propagatedBuildInputs = [ ppx_tools ppx_deriving result ];

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/visitors";
    license = licenses.lgpl21;
    description = "An OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    maintainers = [ maintainers.marsam ];
  };
}
