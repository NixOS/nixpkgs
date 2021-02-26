{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "easygui";
  version = "0.98.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "073f728ca88a77b74f404446fb8ec3004945427677c5618bd00f70c1b999fef2";
  };

  doCheck = false; # No tests available

  meta = with lib; {
    description = "Very simple, very easy GUI programming in Python";
    homepage = "https://github.com/robertlugg/easygui";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
