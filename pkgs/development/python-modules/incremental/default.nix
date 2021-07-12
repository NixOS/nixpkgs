{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "incremental";
  version = "21.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02f5de5aff48f6b9f665d99d48bfc7ec03b6e3943210de7cfc88856d755d6f57";
  };

  meta = with lib; {
    homepage = "https://github.com/twisted/treq";
    description = "Incremental is a small library that versions your Python projects";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
