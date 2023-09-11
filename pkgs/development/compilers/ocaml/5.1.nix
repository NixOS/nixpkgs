import ./generic.nix {
  major_version = "5";
  minor_version = "1";
  patch_version = "0-rc3";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-5.1/ocaml-5.1.0~rc3.tar.xz";
    sha256 = "sha256:0cbvdcsq1qh70mm116dcgk6y7d4g4nrypzq20k7i6ww7am1563d3";
  };
}
