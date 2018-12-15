{ stdenv, fetchFromGitHub, buildDunePackage, doc-ock, menhir, xmlm }:

buildDunePackage rec {
  pname = "doc-ock-xml";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s27ri7vj9ixi5p5ixg6g6invk96807bvxbqjrr1dm8sxgl1nd20";
  };

  propagatedBuildInputs = [ doc-ock menhir xmlm ];

  meta = {
    description = "XML printer and parser for Doc-Ock";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
