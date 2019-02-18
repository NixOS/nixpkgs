{ stdenv, fetchFromGitHub, coq }:

stdenv.mkDerivation rec {
  version = "0.2";
  name = "coq${coq.coq-version}-simple-io-${version}";
  src = fetchFromGitHub {
    owner = "Lysxia";
    repo = "coq-simple-io";
    rev = version;
    sha256 = "1sbcf57gn134risiicpbxsf4kbzdq7klfn4vn8525kahlr82l65f";
  };

  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [ ocaml ocamlbuild ]);

  doCheck = !stdenv.lib.versionAtLeast coq.coq-version "8.9";
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
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.6";
  };

}
