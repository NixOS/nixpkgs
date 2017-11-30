{stdenv, buildOcaml, fetchFromGitHub, ocamlbuild, findlib, topkg, ocaml, opam,
 ppx_tools, ppx_sexp_conv, cstruct, ppx_cstruct, sexplib, result, nocrypto, astring}:

let ocamlFlags = "-I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/"; in

buildOcaml rec {
  name = "otr";
  version = "0.3.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "ocaml-otr";
    rev    = "${version}";
    sha256 = "07zzix5mfsasqpqdx811m0x04gp8mq1ayf4b64998k98027v01rr";
  };

  buildInputs = [ ocamlbuild findlib topkg ppx_tools ppx_sexp_conv opam ppx_cstruct ];
  propagatedBuildInputs = [ cstruct sexplib result nocrypto astring ];

  buildPhase = ''
    ocaml ${ocamlFlags} pkg/pkg.ml build \
      --tests true
  '';

  installPhase = ''
    opam-installer --prefix=$out --script | sh
    ln -s $out/lib/otr $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  doCheck = true;
  checkPhase = "ocaml ${ocamlFlags} pkg/pkg.ml test";

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/hannesm/ocaml-otr;
    description = "Off-the-record messaging protocol, purely in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
