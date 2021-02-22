{ stdenv, lib, fetchurl, ocaml, findlib, cppo, minimal ? true }:

assert lib.versionAtLeast (lib.getVersion ocaml) "3.11";

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-extlib-1.7.7";

  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocaml-extlib/extlib-1.7.7.tar.gz";
    sha256 = "1sxmzc1mx3kg62j8kbk0dxkx8mkf1rn70h542cjzrziflznap0s1";
  };

  buildInputs = [ ocaml findlib cppo ];

  createFindlibDestdir = true;

  dontConfigure = true;      # Skip configure
  # De facto, option minimal=1 seems to be the default.  See the README.
  buildPhase     = "make ${if minimal then "minimal=1" else ""} build";
  installPhase   = "make ${if minimal then "minimal=1" else ""} install";

  meta = {
    homepage = "https://github.com/ygrek/ocaml-extlib";
    description = "Enhancements to the OCaml Standard Library modules";
    license = lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
  };
}
