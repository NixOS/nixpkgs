{ lib, buildPythonPackage, isPy27, fetchPypi, setuptools_scm, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jZ4sHR3OEfe30snQkgLr/HdXt/8MrJtyrTKO3+fuA3s=";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
  };
}
