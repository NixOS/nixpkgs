{ lib, buildDunePackage, fetchFromGitLab, ppxlib, ppx_deriving, result }:

buildDunePackage rec {
  pname = "visitors";
  version = "20210316";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchFromGitLab {
    owner = "fpottier";
    repo = pname;
    rev = version;
    domain = "gitlab.inria.fr";
    sha256 = "12d45ncy3g9mpcs6n58aq6yzs5qz662msgcr7ccms9jhiq44m8f7";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving result ];

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/visitors";
    license = licenses.lgpl21;
    description = "An OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    maintainers = [ maintainers.marsam ];
  };
}
