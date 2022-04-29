import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "1";
  sha256 = "18sycl3zmgb8ghpxymriy5d72gvw7m5ra65v51hcrmzzac21hkyd";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];

  patches = [
    # Compatibility with Glibc 2.34
    { url = "https://github.com/ocaml/ocaml/commit/17df117b4939486d3285031900587afce5262c8c.patch";
      sha256 = "sha256:1b3jc6sj2k23yvfwrv6nc1f4x2n2biqbhbbp74aqb6iyqyjsq35n"; }
  ];
}
