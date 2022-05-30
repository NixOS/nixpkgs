{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b";
  };

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "colorama" ];

  meta = with lib; {
    description = "Cross-platform colored terminal text";
    homepage = "https://github.com/tartley/colorama";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

