{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  pythonOlder,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "marshmallow-polyfield";
  version = "5.11";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Bachmann1234";
    repo = "marshmallow-polyfield";
    rev = "refs/tags/v${version}";
    hash = "sha256-jbpeyih2Ccw1Rk+QcXRO9AfN5B/DhZmxa/M6FzXHqqs=";
  };

  build-system = [ setuptools ];

  dependencies = [ marshmallow ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "marshmallow" ];

  meta = with lib; {
    description = "Extension to Marshmallow to allow for polymorphic fields";
    homepage = "https://github.com/Bachmann1234/marshmallow-polyfield";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
