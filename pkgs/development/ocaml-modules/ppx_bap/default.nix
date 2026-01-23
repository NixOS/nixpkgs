{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  fetchpatch,
  ppx_assert ? null,
  ppx_bench ? null,
  ppx_bin_prot ? null,
  ppx_compare ? null,
  ppx_enumerate ? null,
  ppx_expect,
  ppx_hash,
  ppx_here,
  ppx_optcomp,
  ppx_sexp_conv,
  ppx_sexp_value ? null,
}:

buildDunePackage rec {
  pname = "ppx_bap";
  version = "0.14";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c6rcdp8bicdiwqc2mb59cl9l2vxlp3y8hmnr9x924fq7acly248";
  };

  # Support ppx_expect
  patches = fetchpatch {
    url = "https://github.com/BinaryAnalysisPlatform/ppx_bap/commit/7f197648978758fbcbf553da50d7a9248d34f7e4.patch";
    hash = "sha256-oOdcA06mb0W5jDhF4nutEijy6yu/6kMjKOUcNxUSk6k=";
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
    ppx_expect
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
