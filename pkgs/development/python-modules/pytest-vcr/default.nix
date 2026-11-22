{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "pytest-vcr";
  version = "1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ktosiek";
    repo = "pytest-vcr";
    rev = version;
    hash = "sha256-0Win4yPz536CMkPeqgdxIdXg+OY6ui9RXJvOGpKNzsQ=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ vcrpy ];

  # Tests are using an obsolete attribute 'config'
  # https://github.com/ktosiek/pytest-vcr/issues/43
  doCheck = false;
  pythonImportsCheck = [ "pytest_vcr" ];

  meta = {
    description = "Integration VCR.py into pytest";
    homepage = "https://github.com/ktosiek/pytest-vcr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
