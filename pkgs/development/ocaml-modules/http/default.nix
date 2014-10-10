{stdenv, fetchurl, ocaml_pcre, ocamlnet, ocaml, findlib, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "ocaml-http";
  version = "0.1.3";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://upsilon.cc/~zack/hacking/software/${pname}/${pname}-${version}.tar.gz";
    sha256 = "070xw033r4pk6f4l0wcknm75y9qm4mp622a4cgzmcfhm58v6kssn";
  };

  buildInputs = [ocaml_pcre ocamlnet ocaml findlib camlp4];

  createFindlibDestdir = true;

  prePatch = ''
    BASH=$(type -tp bash)
    echo $BASH
    substituteInPlace Makefile --replace "SHELL=/bin/bash" "SHELL=$BASH"
  '';

  configurePhase = "true";	# Skip configure phase

  buildPhase = ''
    make all opt
  '';

  meta = with stdenv.lib; {
    homepage = "http://upsilon.cc/~zack/hacking/software/ocaml-http/";
    description = "do it yourself (OCaml) HTTP daemon";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ roconnor vbgl ];
  };
}
