{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-extlib-1.6.1";

  src = fetchurl {
    url = http://ocaml-extlib.googlecode.com/files/extlib-1.6.1.tar.gz;
    sha256 = "1jmfj2w0f3ap0swz8k3qqmrl6x2y4gkmg88vv024xnmliiiv7m48";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  configurePhase = "true";      # Skip configure
  # De facto, option minimal=1 seems to be the default.  See the README.
  buildPhase     = "make minimal=1 build";
  installPhase   = "make minimal=1 install";

  meta = {
    homepage = http://code.google.com/p/ocaml-extlib/;
    description = "Enhancements to the OCaml Standard Library modules";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
  };
}
