import ./generic.nix {
  major_version = "4";
  minor_version = "02";
  patch_version = "3";
  patches = [
    ./ocamlbuild.patch

    # Compatibility with Glibc 2.34
    {
      url = "https://github.com/ocaml/ocaml/commit/9de2b77472aee18a94b41cff70caee27fb901225.patch";
      sha256 = "sha256:12sw512kpwk0xf2g6j0h5vqgd8xcmgrvgyilx6fxbd6bnfv1yib9";
    }
    # Compatibility with Binutils 2.29
    {
      url = "https://github.com/ocaml/ocaml/commit/bcc7a767279ff70518b3f4219cc0b9bffec7dd43.patch";
      sha256 = "sha256-z3xrqN6bh/EW9dkPg6Hz8mT79DFm26yGRoPbE+RMYi0=";
    }
  ];
  sha256 = "1qwwvy8nzd87hk8rd9sm667nppakiapnx4ypdwcrlnav2dz6kil3";

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
}
