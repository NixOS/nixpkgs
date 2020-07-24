{ callPackage, texinfo, perl }:

callPackage ./common.nix {} {
  name = "glibc-info";

  outputs = [ "out" ];

  configureFlags = [ "--enable-add-ons" ];

  buildInputs = [ texinfo perl ];

  buildPhase = "make info";

  # I don't know why the info is not generated in 'build'
  # Somehow building the info still does not work, because the final
  # libc.info hasn't a Top node.
  installPhase = ''
    mkdir -p "$out/share/info"
    cp -v "manual/"*.info* "$out/share/info"
  '';

  meta.description = "GNU Info manual of the GNU C Library";
}
