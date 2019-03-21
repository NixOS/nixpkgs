{ stdenv, fetchurl, ocaml, findlib, cppo, minimal ? true }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.11";

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-extlib-1.7.5";

  src = fetchurl {
    url = http://ygrek.org.ua/p/release/ocaml-extlib/extlib-1.7.5.tar.gz;
    sha256 = "19slqf5bdj0rrph2w41giwmn6df2qm07942jn058pjkjrnk30d4s";
  };

  buildInputs = [ ocaml findlib cppo ];

  createFindlibDestdir = true;

  configurePhase = "true";      # Skip configure
  # De facto, option minimal=1 seems to be the default.  See the README.
  buildPhase     = "make ${if minimal then "minimal=1" else ""} build";
  installPhase   = "make ${if minimal then "minimal=1" else ""} install";

  meta = {
    homepage = https://github.com/ygrek/ocaml-extlib;
    description = "Enhancements to the OCaml Standard Library modules";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
  };
}
