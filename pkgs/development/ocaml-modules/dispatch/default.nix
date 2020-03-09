{ lib, buildDunePackage, fetchFromGitHub, alcotest, result }:

buildDunePackage rec {
  pname = "dispatch";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-dispatch";
    rev = "${version}";
    sha256 = "05kb9zcihk50r2haqz8vrlr7kmaka6vrs4j1z500lmnl877as6qr";
  };

  propagatedBuildInputs = [ result ];

  checkInputs = lib.optional doCheck alcotest;

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    description = "Path-based dispatching for client- and server-side applications";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
