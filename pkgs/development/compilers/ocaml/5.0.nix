import ./generic.nix {
  major_version = "5";
  minor_version = "0";
  patch_version = "0-beta2";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-5.0/ocaml-5.0.0~beta2.tar.xz";
    sha256 = "sha256:1r76a3wadidca9306wkkcxdh5l0rk93pc6xmbs46cc1jfm6pgwas";
  };
}
