import ./generic.nix {
  major_version = "5";
  minor_version = "0";
  patch_version = "0-beta1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-5.0/ocaml-5.0.0~beta1.tar.xz";
    sha256 = "sha256:1kwb53ra5qbwiiyrx5da7l5mqkjf0fr3rqgkrm3wr83l25scimj4";
  };
}
