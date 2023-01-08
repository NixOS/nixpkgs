{ lib, buildPythonPackage, fetchPypi, yajl, cffi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.2.0.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gKW9fpkjyrIAcB9nrSNyEEMouZ3fJJ276INBAshS0xY=";
  };

  buildInputs = [ yajl ];
  propagatedBuildInputs = [ cffi ];
  checkInputs = [ pytestCheckHook ];

  doCheck = true;

  meta = with lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
