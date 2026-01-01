{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
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

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # can't find hostname in our darwin build environment
    "test_fqdn"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "ephemeral_port_reserve" ];

<<<<<<< HEAD
  meta = {
    description = "Find an unused port, reliably";
    mainProgram = "ephemeral-port-reserve";
    homepage = "https://github.com/Yelp/ephemeral-port-reserve/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Find an unused port, reliably";
    mainProgram = "ephemeral-port-reserve";
    homepage = "https://github.com/Yelp/ephemeral-port-reserve/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
