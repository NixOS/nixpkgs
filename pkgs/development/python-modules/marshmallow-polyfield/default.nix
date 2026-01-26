{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "marshmallow-polyfield";
  version = "5.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bachmann1234";
    repo = "marshmallow-polyfield";
    tag = "v${version}";
    hash = "sha256-jbpeyih2Ccw1Rk+QcXRO9AfN5B/DhZmxa/M6FzXHqqs=";
  };

  build-system = [ setuptools ];

  dependencies = [ marshmallow ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "marshmallow" ];

  meta = {
    # https://github.com/Bachmann1234/marshmallow-polyfield/issues/45
    broken = true;
    description = "Extension to Marshmallow to allow for polymorphic fields";
    homepage = "https://github.com/Bachmann1234/marshmallow-polyfield";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
