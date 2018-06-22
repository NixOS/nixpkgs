{ lib, buildPythonPackage, fetchPypi, pytestcache, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4d195ecfe33d81e258d251b2679b32216bad84131fb41984da22d9d0328a6fe";
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
