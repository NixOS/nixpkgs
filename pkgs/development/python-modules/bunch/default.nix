{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bunch";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1akalx2pd1fjlvrq69plvcx783ppslvikqdm93z2sdybq07pmish";
  };

  doCheck = false;

  meta = with lib; {
    maintainers = with maintainers; [ ];
  };
}
