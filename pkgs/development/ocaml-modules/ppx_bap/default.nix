{ lib, buildDunePackage
, fetchFromGitHub
, ppx_assert
, ppx_bench
, ppx_bin_prot
, ppx_compare
, ppx_enumerate
, ppx_hash
, ppx_here
, ppx_optcomp
, ppx_sexp_conv
, ppx_sexp_value
}:

buildDunePackage rec {
  pname = "ppx_bap";
  version = "0.14";
  duneVersion = "3";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c6rcdp8bicdiwqc2mb59cl9l2vxlp3y8hmnr9x924fq7acly248";
  };

  buildInputs = [
    ppx_optcomp
    ppx_sexp_value
  ];

  propagatedBuildInputs = [
    ppx_assert
    ppx_bench
    ppx_bin_prot
    ppx_compare
    ppx_enumerate
    ppx_hash
    ppx_here
    ppx_sexp_conv
  ];

  meta = {
    description = "Set of ppx rewriters for BAP";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "ppx-bap";
  };
}
