{ lib, buildDunePackage, fetchFromGitHub, alcotest, digestif, fmt, yojson
, ppxlib
, base64, re, ppx_deriving }:

buildDunePackage rec {
  pname = "jwto";
  version = "0.4.0";

  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "sporto";
    repo = "jwto";
    rev = version;
    hash = "sha256-TOWwNyrOqboCm8Y4mM6GgtmxGO3NmyDdAX7m8CifA7Y=";
  };

  buildInputs = [ ppxlib ];

  propagatedBuildInputs =
    [ digestif fmt yojson base64 re ppx_deriving ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/sporto/jwto";
    description = "JSON Web Tokens (JWT) for OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zimmi48 jtcoolen ];
  };
}
