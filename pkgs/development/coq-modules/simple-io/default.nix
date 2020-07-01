{ stdenv, fetchFromGitHub, coq, coq-ext-lib }:

stdenv.mkDerivation rec {
  version = "1.3.0";
  name = "coq${coq.coq-version}-simple-io-${version}";
  src = fetchFromGitHub {
    owner = "Lysxia";
    repo = "coq-simple-io";
    rev = version;
    sha256 = "1yp7ca36jyl9kz35ghxig45x6cd0bny2bpmy058359p94wc617ax";
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
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" "8.10" "8.11" ];
  };

}
