{stdenv, fetchurl, ocaml, findlib, pgocaml, camlp4}:

stdenv.mkDerivation {
  name = "ocaml-macaque-0.7.1";
  src = fetchurl {
    url = https://github.com/ocsigen/macaque/archive/0.7.1.tar.gz;
    sha256 = "0wnq3pgpcrfpivr8j7p827rhag6hdx0yr0bdvma0hw1g30vwf9qa";
  };

  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ pgocaml ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "Macros for Caml Queries";
    homepage = https://github.com/ocsigen/macaque;
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [ vbgl ];
  };
}
