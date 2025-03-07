import ./generic.nix {
  major_version = "4";
  minor_version = "07";
  patch_version = "1";
  sha256 = "1f07hgj5k45cylj1q3k5mk8yi02cwzx849b1fwnwia8xlcfqpr6z";

  # If the executable is stripped it does not work
  dontStrip = true;

  patches = [
    # Compatibility with Glibc 2.34
    {
      url = "https://github.com/ocaml/ocaml/commit/00b8c4d503732343d5d01761ad09650fe50ff3a0.patch";
      sha256 = "sha256:02cfya5ff5szx0fsl5x8ax76jyrla9zmf3qxavf3adhwq5ssrfcv";
    }
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
}
