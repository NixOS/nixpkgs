import ./generic.nix {
  major_version = "4";
  minor_version = "05";
  patch_version = "0";
  sha256 = "1y9fw1ci9pwnbbrr9nwr8cq8vypcxwdf4akvxard3mxl2jx2g984";

  # If the executable is stipped it does not work
  dontStrip = true;

  patches = [
    # Compatibility with Glibc 2.34
    {
      url = "https://github.com/ocaml/ocaml/commit/50c2d1275e537906ea144bd557fde31e0bf16e5f.patch";
      sha256 = "sha256:0ck9b2dpgg5k2p9ndbgniql24h35pn1bbpxjvk69j715lswzy4mh";
    }
    # Compatibility with Binutils 2.29
    {
      url = "https://github.com/ocaml/ocaml/commit/b00000c6679804731692362b0baac27fa3fddfd5.patch";
      sha256 = "sha256-CuEXGK3EsOevyUrc9TmSZo9DVBwjunQX7mKnDVHFpkY=";
    }
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
}
