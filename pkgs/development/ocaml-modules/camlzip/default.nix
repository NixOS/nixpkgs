{stdenv, fetchurl, zlib, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.05";
in

stdenv.mkDerivation {
  name = "camlzip-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1037/" +
          "camlzip-${version}.tar.gz";
    sha256 = "930b70c736ab5a7ed1b05220102310a0a2241564786657abe418e834a538d06b";
  };

  buildInputs = [zlib ocaml findlib];

  patches = [ ./makefile.patch ];

  createFindlibDestdir = true;

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
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
