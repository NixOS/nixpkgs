{ stdenv, fetchurl, texinfo, perl }:

let build = import ./common.nix; in

/* null cross builder */
build null {
  name = "glibc-info";

  inherit fetchurl stdenv;

  configureFlags = [ "--enable-add-ons" ];

  buildInputs = [ texinfo perl ];

  buildPhase = "make info";

  # I don't know why the info is not generated in 'build'
  # Somehow building the info still does not work, because the final
  # libc.info hasn't a Top node.
  installPhase = ''
    mkdir -p "$out/share/info"
    cp -v "../$sourceRoot/manual/"*.info* "$out/share/info"
  '';

  meta.description = "GNU Info manual of the GNU C Library";
}
