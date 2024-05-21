{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
  hypothesis,
  pkgs,
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlsfuzzer";
    repo = "python-ecdsa";
    rev = "python-ecdsa-${version}";
    hash = "sha256-yDhTlc0adNo+RzVpP+L4D73Av+NbcvJ1uNB2hUxXsBA=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pkgs.openssl # Only needed for tests
  ];

  meta = with lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/tlsfuzzer/python-ecdsa";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
