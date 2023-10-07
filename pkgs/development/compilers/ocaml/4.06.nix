import ./generic.nix {
  major_version = "4";
  minor_version = "06";
  patch_version = "1";
  sha256 = "1n3pygfssd6nkrq876wszm5nm3v4605q4k16a66h1nmq9wvf01vg";

  # If the executable is stipped it does not work
  dontStrip = true;

  patches = [
    # Compatibility with Glibc 2.34
    { url = "https://github.com/ocaml/ocaml/commit/137a4ad167f25fe1bee792977ed89f30d19bcd74.patch";
      sha256 = "sha256:0izsf6rm3677vbbx0snkmn9pkfcsayrdwz3ipiml5wjiaysnchjz"; }
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
}
