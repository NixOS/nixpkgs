{ stdenv, fetchFromGitHub, coq }:

let params =
  {
    "8.7" = {
      sha256 = "09n0ky7ldb24by7yf5j3hv410h85x50ksilf7qacl7xglj4gy5hj";
      buildInputs = [ coq.ocamlPackages.camlp5 ];
    };
    "8.8" = {
      sha256 = "0rc4lshqvnfdsph98gnscvpmlirs9wx91qcvffggg73xw0p1g9s0";
      buildInputs = [ coq.ocamlPackages.camlp5 ];
    };
    "8.9" = {
      sha256 = "1jjzgpff09xjn9kgp7w69r096jkj0x2ksng3pawrmhmn7clwivbk";
      buildInputs = [ coq.ocamlPackages.camlp5 ];
    };
    "8.10" = {
      sha256 = "1lq1mw15w4yky79qg3rm0mpzqi2ir51b6ak04ismrdr7ixky49y8";
    };
    "8.11" = {
      sha256 = "09c6813988nvq4fpa45s33k70plnhxsblhm7cxxkg0i37mhvigsa";
    };
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "coq${coq.coq-version}-paramcoq-${version}";
  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "paramcoq";
    rev = "v${version}+coq${coq.coq-version}";
    inherit (param) sha256;
  };

  buildInputs = [ coq ]
  ++ (with coq.ocamlPackages; [ ocaml findlib ])
  ++ (param.buildInputs or [])
  ;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

  meta = {
    description = "Coq plugin for parametricity";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };
}
