{ lib, fetchFromGitHub, buildDunePackage, pkg-config, configurator, stdio, R }:

buildDunePackage rec {
  pname = "ocaml-r";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "09gljccwjsw9693m1hm9hcyvgp3p2fvg3cfn18yyidpc2f81a4fy";
  };

  # Without the following patch, stub generation fails with:
  # > Fatal error: exception (Failure "not supported: osVersion")
  preConfigure = ''
    substituteInPlace stubgen/stubgen.ml --replace  \
    'failwithf "not supported: %s" name ()' \
    'sprintf "(* not supported: %s *)" name'
  '';

  buildInputs = [ configurator pkg-config R stdio ];

  meta = {
    description = "OCaml bindings for the R interpreter";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };

}
