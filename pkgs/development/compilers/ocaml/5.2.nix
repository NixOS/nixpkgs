import ./generic.nix {
  major_version = "5";
  minor_version = "2";
  patch_version = "0-beta2";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-5.2/ocaml-5.2.0~beta2.tar.xz";
    sha256 = "sha256:1cyw0w79j7kyr3x0ivsqm1si704b29ic33yj621dq7f125jabk00";
  };
}
