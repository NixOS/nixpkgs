import ./generic.nix {
  major_version = "4";
  minor_version = "01";
  patch_version = "0";
  patches = [
    ./fix-clang-build-on-osx.diff

    # Compatibility with Glibc 2.34
    {
      url = "https://github.com/ocaml/ocaml/commit/d111407bf4ff71171598d30825c8e59ed5f75fd6.patch";
      sha256 = "sha256:08mpy7lsiwv8m5qrqc4xzyiv2hri5713gz2qs1nfz02hz1bd79mc";
    }
  ];
  sha256 = "03d7ida94s1gpr3gadf4jyhmh5rrszd5s4m4z59daaib25rvfyv7";

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
}
