import ./generic.nix {
  major_version = "4";
  minor_version = "12";
  patch_version = "0-alpha2";
  src = fetchTarball {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0~alpha2.tar.xz";
    sha256 = "148vgjcfajjvrvh0q9kb2y7fszqd02cikb5wyznz7kjxka6xxyn9";
  };
}
