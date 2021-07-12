{ lib, buildPythonPackage, fetchPypi, packaging, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee8e9af118ff55ed13bf8e8b520714c52665ae44f6228563a600a08d62839b54";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ packaging ];

  # pypi does not contain tests and GitHub archive is not supported because setuptools-scm can't detect the version
  doCheck = false;
  pythonImportsCheck = [ "pytest_snapshot" ];

  meta = with lib; {
    description = "A plugin to enable snapshot testing with pytest";
    homepage = "https://github.com/joseph-roitman/pytest-snapshot/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
