{ lib, buildDunePackage, fetchFromGitLab
, ppxlib, ppx_deriving, result
, cppo, core_bench
}:

buildDunePackage rec {
  pname = "visitors";
  version = "unstable-2020-11-12";
  # 20201112 has a changelog entry, but no release tag

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchFromGitLab {
    owner = "fpottier";
    repo = pname;
    rev = "ffa92a0fdfdfe7e8ea12a53cfc7d51d1f3f34d5b";
    domain = "gitlab.inria.fr";
    sha256 = "14b86nh0jlsj71qxzzdkqp2zyah6czhnfb7djakghwl6633445ci";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving result ];

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/visitors";
    license = licenses.lgpl21;
    description = "An OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    maintainers = [ maintainers.marsam ];
  };
}
