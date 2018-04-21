{ lib, buildPythonPackage, fetchPypi, pytestcache, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e92798127e21d22513c62070989f0fb3b712650e48a4db13e5b8e8034d367cfe";
  };

  propagatedBuildInputs = [ pytestcache pytest isort ];

  # no tests in PyPI tarball, no tags on GitHub
  # https://github.com/moccu/pytest-isort/pull/8
  doCheck = false;

  meta = with lib; {
    description = "Pytest plugin to perform isort checks (import ordering)";
    homepage = https://github.com/moccu/pytest-isort/;
    license = licenses.bsd3;
  };
}
