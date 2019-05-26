{ stdenv, fetchFromGitHub, coq, coq-ext-lib }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "coq${coq.coq-version}-simple-io-${version}";
  src = fetchFromGitHub {
    owner = "Lysxia";
    repo = "coq-simple-io";
    rev = version;
    sha256 = "06gnbl8chv6ig18rlxnp8gg0np6863kxd7j15h46q0v1cnpx84lp";
  };

  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [ ocaml ocamlbuild ]);

  propagatedBuildInputs = [ coq-ext-lib ];

  doCheck = true;
  checkTarget = "test";

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    description = "Purely functional IO for Coq";
    inherit (src.meta) homepage;
    inherit (coq.meta) platforms;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" ];
  };

}
