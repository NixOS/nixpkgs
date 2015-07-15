{stdenv, fetchurl, ocaml, camlp4, findlib, mirage-types}:

stdenv.mkDerivation {
  name = "ocaml-mirage-clock-unix-1.0.0";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-clock/archive/v1.0.0/ocaml-mirage-clock-unix-1.0.0.tar.gz";
    sha256 = "1lvgp9wvamrd3h5ql4rj61ypjq9xjmmnanqd6v5gv2l9398skhid";
  };

  buildInputs = [ ocaml camlp4 findlib mirage-types ];

  configurePhase = "true";

  buildPhase = ''
    make unix-build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make unix-install
    '';

  meta = {
    homepage = https://github.com/mirage/mirage-clock/;
    description = "A Mirage-compatible Clock library for Unix";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
