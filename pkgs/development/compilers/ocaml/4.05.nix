import ./generic.nix {
  major_version = "4";
  minor_version = "05";
  patch_version = "0";
  sha256 = "1y9fw1ci9pwnbbrr9nwr8cq8vypcxwdf4akvxard3mxl2jx2g984";

  # If the executable is stipped it does not work
  dontStrip = true;

  patches = [
    # Compatibility with Glibc 2.34
    { url = "https://github.com/ocaml/ocaml/commit/50c2d1275e537906ea144bd557fde31e0bf16e5f.patch";
      sha256 = "sha256:0ck9b2dpgg5k2p9ndbgniql24h35pn1bbpxjvk69j715lswzy4mh"; }
  ];
}
