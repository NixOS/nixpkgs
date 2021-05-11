{ lib
, buildPythonPackage
, fetchPypi
, pbr
, pretend
, pyelftools
, pytest
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "auditwheel";
  version = "4.0.0";

  disabled = ! pythonAtLeast "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03a079fe273f42336acdb5953ff5ce7578f93ca6a832b16c835fe337a1e2bd4a";
  };

  buildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    pyelftools
  ];

  checkInputs = [
    pretend
    pytest
  ];

  # integration tests require docker and networking
  checkPhase = "pytest --ignore=tests/integration";

  meta = with lib; {
    description = "Cross-distribution Linux wheels";
    homepage = https://github.com/pypa/auditwheel;
    license = licenses.mit;
    maintainers = with maintainers; [ davhau ];
  };
}
