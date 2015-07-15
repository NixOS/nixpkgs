{stdenv, fetchurl, ocaml, camlp4, findlib, type_conv}:

stdenv.mkDerivation {
  name = "ocaml-dyntype-0.9.0";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/mirage/dyntype/archive/dyntype-0.9.0.tar.gz";
    sha256 = "1l5i5924wf3bdw4z9mbg9f8v29nymymf9kg9lk723l8kfrzl3sb0";
  };

  buildInputs = [ ocaml camlp4 findlib type_conv ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/dyntype/;
    description = "syntax extension which makes OCaml types and values easier to manipulate programmatically";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
