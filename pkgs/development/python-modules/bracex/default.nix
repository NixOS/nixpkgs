{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "bracex";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c8d1296e00ad9a91030ccb4c291f9e4dc7c054f12c707ba3c5ff3e9a81bcd21";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bracex" ];

  meta = with lib; {
    description = "Bash style brace expansion for Python";
    homepage = "https://github.com/facelessuser/bracex";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
