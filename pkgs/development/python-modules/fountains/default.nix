{ lib
, buildPythonPackage
, fetchPypi
, bitlist
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jk5y099g6ggaq5lwp0jlg4asyhcdxnl3him3ibmzc1k9nnknp30";
  };

  propagatedBuildInputs = [
    bitlist
  ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "fountains" ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
