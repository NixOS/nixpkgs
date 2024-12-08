import ./generic.nix {
  major_version = "4";
  minor_version = "09";
  patch_version = "1";
  sha256 = "1aq5505lpa39garky2icgfv4c7ylpx3j623cz9bsz5c466d2kqls";

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];

  patches = [
    ./4.09.1-Werror.patch
    # Compatibility with Glibc 2.34
    { url = "https://github.com/ocaml/ocaml/commit/8eed2e441222588dc385a98ae8bd6f5820eb0223.patch";
      sha256 = "sha256:1b3jc6sj2k23yvfwrv6nc1f4x2n2biqbhbbp74aqb6iyqyjsq35n"; }
  ];
}
