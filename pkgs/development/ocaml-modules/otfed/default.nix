{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  base,
  ppx_deriving,
  ppx_inline_test,
  uutf,
  alcotest,
}:

buildDunePackage rec {
  pname = "otfed";
  version = "0.3.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "gfngfn";
    repo = pname;
    rev = version;
    hash = "sha256-6QCom9nrz0B5vCmuBzqsM0zCs8tBLJC6peig+vCgMVA=";
  };

  buildInputs = [
    uutf
  ];

  propagatedBuildInputs = [
    base
    ppx_deriving
    ppx_inline_test
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/gfngfn/otfed";
    description = "OpenType Font Format Encoder & Decoder";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
