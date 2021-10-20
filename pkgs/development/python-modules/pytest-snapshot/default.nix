{ lib, buildPythonPackage, fetchPypi, packaging, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "427b5ab088b25a1c8b63ce99725040664c840ff1f5a3891252723cce972897f9";
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
