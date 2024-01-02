import ./generic.nix {
  major_version = "4";
  minor_version = "03";
  patch_version = "0";
  sha256 = "09p3iwwi55r6rbrpyp8f0wmkb0ppcgw67yxw6yfky60524wayp39";

  patches = [
    # Compatibility with Glibc 2.34
    { url = "https://github.com/ocaml/ocaml/commit/a8b2cc3b40f5269ce8525164ec2a63b35722b22b.patch";
      sha256 = "sha256:1rrknmrk86xrj2k3hznnjk1gwnliyqh125zabg1hvy6dlvml9b0x"; }
    # Compatibility with Binutils 2.29
    { url = "https://github.com/ocaml/ocaml/commit/c204f07bfb20174f9e1c9ff586fb7b2f42b8bf18.patch";
      sha256 = "sha256-AAXyMZ7ujO67SGz+tGXKZkVcINAwvccHlFHmKnUt848="; }
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
}
