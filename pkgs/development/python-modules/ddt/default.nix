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
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8de39a69730442dc835e4d33f9d2e33043ff91151c8d18086959ee556febb9f8";
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
