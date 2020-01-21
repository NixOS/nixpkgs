{ stdenv, fetchFromGitHub, coq }:

let params =
  {
    "8.7" = {
      version = "1.1.1+coq8.7";
      sha256 = "1i7b5pkx46zf9il2xikbp3rhpnh3wdfbhw5yxcf9yk28ky9s0a0l";
    };
    "8.8" = {
      version = "1.1.1";
      sha256 = "0b07zvgm9cx6j2d9631zmqjs6sf30kiqg6k15xk3km7n80d53wfh";
    };
    "8.9" = {
      version = "1.1.1+coq8.9";
      sha256 = "002xabhjlph394vydw3dx8ipv5ry2nq3py4440bk9a18ljx0w6ll";
    };
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-paramcoq-${version}";
  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "paramcoq";
    rev = "v${version}";
    inherit (param) sha256;
  };

  buildInputs = [ coq ]
  ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ])
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
