{stdenv, fetchurl, ocaml, findlib, camlp4, minimal ? true}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.11";

stdenv.mkDerivation {
  name = "ocaml-extlib-1.6.1";

  src = fetchurl {
    url = http://ocaml-extlib.googlecode.com/files/extlib-1.6.1.tar.gz;
    sha256 = "1jmfj2w0f3ap0swz8k3qqmrl6x2y4gkmg88vv024xnmliiiv7m48";
  };

  buildInputs = [ocaml findlib camlp4];

  createFindlibDestdir = true;

  configurePhase = "true";      # Skip configure
  # De facto, option minimal=1 seems to be the default.  See the README.
  buildPhase     = "make ${if minimal then "minimal=1" else ""} build";
  installPhase   = "make ${if minimal then "minimal=1" else ""} install";

  meta = {
    homepage = http://code.google.com/p/ocaml-extlib/;
    description = "Enhancements to the OCaml Standard Library modules";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
