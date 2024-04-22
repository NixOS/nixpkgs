{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pytest-dependency";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k0sOajnZWZUGLBk/fq7tio/6Bv8bzvS2Kw3HSnCLrME=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_dependency"
  ];

  meta = with lib; {
    homepage = "https://github.com/RKrahl/pytest-dependency";
    changelog = "https://github.com/RKrahl/pytest-dependency/blob/${version}/CHANGES.rst";
    description = "Manage dependencies of tests";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
