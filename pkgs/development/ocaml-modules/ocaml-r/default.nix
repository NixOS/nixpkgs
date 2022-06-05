{ lib, fetchFromGitHub, buildDunePackage, pkg-config, dune-configurator, stdio, R
, alcotest
}:

buildDunePackage rec {
  pname = "ocaml-r";
  version = "0.4.0";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "10is2s148kfh3g0pwniyzp5mh48k57ldvn8gm86469zvgxyij1ri";
  };

  # Without the following patch, stub generation fails with:
  # > Fatal error: exception (Failure "not supported: osVersion")
  preConfigure = ''
    substituteInPlace stubgen/stubgen.ml --replace  \
    'failwithf "not supported: %s" name ()' \
    'sprintf "(* not supported: %s *)" name'
    substituteInPlace lib/config/discover.ml --replace \
    ' libRmath"' '"'
  '';

  # This currently fails with dune
  strictDeps = false;

  nativeBuildInputs = [ pkg-config R ];
  buildInputs = [ dune-configurator stdio R ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "OCaml bindings for the R interpreter";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };

}
