{ lib, buildDunePackage, fetchFromGitHub, alcotest, cryptokit, fmt, yojson
, ppxlib
, base64, re, ppx_deriving }:

buildDunePackage rec {
  pname = "jwto";
  version = "0.3.0";

  useDune2 = true;

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "sporto";
    repo = "jwto";
    rev = version;
    sha256 = "1p799zk8j9c0002xzi2x7ndj1bzqf14744ampcqndrjnsi7mq71s";
  };

  buildInputs = [ ppxlib ];

  propagatedBuildInputs =
    [ cryptokit fmt yojson base64 re ppx_deriving ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/sporto/jwto";
    description = "JSON Web Tokens (JWT) for OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zimmi48 jtcoolen ];
  };
}
