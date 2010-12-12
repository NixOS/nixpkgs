{stdenv, fetchurl, zlib, ocaml, findlib}:

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

  buildInputs = [zlib ocaml findlib];

  patches = [ ./makefile.patch ];

  postPatch = ''
    substitute ${./META} META --subst-var-by VERSION "${version}"
    substituteInPlace Makefile \
      --subst-var-by ZLIB_LIBDIR "${zlib}/lib" \
      --subst-var-by ZLIB_INCLUDE "${zlib}/include"
  '';

  buildFlags = "all allopt";

  installTargets = "install";

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
