{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:
ocamlPackages.buildDunePackage rec {
  pname = "hardcaml";
  version = "v0.17.0";

  minimalOCamlVersion = "5.1.0";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "hardcaml";
    rev = version;
    hash = "sha256-lRzqXuUYrk3VjQhFDTN0Q/aPolf0gKr4gK0i1ZOKKww=";
  };

  buildInputs = with ocamlPackages; [
    base
		bignum
    bin_prot
    core
    core_kernel
		janeStreet.jane_rope
		janeStreet.ppx_compare
    janeStreet.ppx_jane
    # janeStreet.ppx_rope
    janeStreet.ppx_sexp_conv
    sexplib
		janeStreet.splittable_random
    stdio
		ppxlib
  ];

  # doCheck = true;

  meta = {
    homepage = "https://github.com/janestreet/hardcaml/tree/master";
    description = "Hardcaml is an OCaml library for designing hardware";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jleightcap ];
  };
}
