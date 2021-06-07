{ lib
, buildPythonPackage
, fetchPypi
, six, pyyaml, mock
, pytestCheckHook
, enum34
, isPy3k
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZKZzZqJxXmNriGlMxgdcwC2ykvAQmLjjhTl8iU05U3g=";
  };

  checkInputs = [ six pyyaml mock pytestCheckHook ];

  propagatedBuildInputs = lib.optionals (!isPy3k) [
    enum34
  ];

  meta = with lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = "https://github.com/txels/ddt";
    license = licenses.mit;
  };

}
