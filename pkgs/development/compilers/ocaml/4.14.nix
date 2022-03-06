import ./generic.nix {
  major_version = "4";
  minor_version = "14";
  patch_version = "0-beta1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.0~beta1.tar.xz";
    sha256 = "0jiz20hb58jbbk8j38agx11ra4hg0v3prmzc5a9j70lm09mnzfcd";
  };
}
