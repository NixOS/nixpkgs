{ lib, buildDunePackage, fetchFromGitHub, ocaml, alcotest, result }:

buildDunePackage rec {
  pname = "dispatch";
  version = "0.5.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-dispatch";
    rev = version;
    sha256 = "12r39ylbxc297cbwjadhd1ghxnwwcdzfjk68r97wim8hcgzxyxv4";
  };

  propagatedBuildInputs = [ result ];

  checkInputs = [ alcotest ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    description = "Path-based dispatching for client- and server-side applications";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
