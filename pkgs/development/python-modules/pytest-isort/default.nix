{ lib, buildPythonPackage, fetchPypi, pytestcache, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c70d0f900f4647bb714f0843dd82d7f7b759904006de31254efdb72ce88e0c0e";
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
