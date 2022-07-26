{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

let
  pname = "ephemeral-port-reserve";
  version = "1.1.4";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "ephemeral-port-reserve";
    rev = "v${version}";
    hash = "sha256-R6NRpfaT05PO/cTWgCakiGfCuCyucjVOXbAezn5x1cU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # can't find hostname in our darwin build environment
    "test_fqdn"
  ];

  pythonImportsCheck = [
    "ephemeral_port_reserve"
  ];

  meta = with lib; {
    description = "Find an unused port, reliably";
    homepage = "https://github.com/Yelp/ephemeral-port-reserve/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
