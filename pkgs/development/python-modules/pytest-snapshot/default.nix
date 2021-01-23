{ lib, buildPythonPackage, fetchPypi, packaging, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p33fcplfykwf5mdwg25n8hjgzxpx8w1iprjnfzibpxclfrxmy5i";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ packaging pytest ];

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
