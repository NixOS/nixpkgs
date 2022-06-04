import ./generic.nix {
  major_version = "4";
  minor_version = "04";
  patch_version = "2";
  sha256 = "0bhgjzi78l10824qga85nlh18jg9lb6aiamf9dah1cs6jhzfsn6i";

  # If the executable is stipped it does not work
  dontStrip = true;

  patches = [
    # Compatibility with Glibc 2.34
    { url = "https://github.com/ocaml/ocaml/commit/6bcff7e6ce1a43e088469278eb3a9341e6a2ca5b.patch";
      sha256 = "sha256:1hd45f7mwwrrym2y4dbcwklpv0g94avbz7qrn81l7w8mrrj3bngi"; }
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";
}
