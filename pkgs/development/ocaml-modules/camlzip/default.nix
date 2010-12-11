{stdenv, fetchurl, zlib, ocaml}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.04";
in

stdenv.mkDerivation {
  name = "camlzip-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/328/" +
          "camlzip-${version}.tar.gz";
    sha256 = "1zpchmp199x7f4mzmapvfywgy7f6wy9yynd9nd8yh8l78s5gixbn";
  };

  buildInputs = [zlib ocaml];

  patches = [ ./makefile.patch ];

  configurePhase = ''
    export INSTALLDIR="$out/lib/ocaml/${ocaml_version}/site-lib/zip"
    substituteInPlace Makefile \
      --subst-var-by ZLIB_LIBDIR "${zlib}/lib" \
      --subst-var-by ZLIB_INCLUDE "${zlib}/include" \
      --subst-var INSTALLDIR
  '';

  buildFlags = "all allopt";

  installTargets = "install installopt";

  postInstall = ''
    substitute ${./META} $INSTALLDIR/META --subst-var INSTALLDIR
  '';

  meta = {
    homepage = "http://cristal.inria.fr/~xleroy/software.html#camlzip";
    description = "A library for handling ZIP and GZIP files in OCaml";
    longDescription = ''
      This Objective Caml library provides easy access to compressed files in
      ZIP and GZIP format, as well as to Java JAR files.  It provides functions
      for reading from and writing to compressed files in these formats.
    '';
    license = "LGPL+linking exceptions";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
