{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "python-trovo";
  version = "0.1.6";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g1RDHSNGbGT1G2ej7A8WzyR17FaNPySfsAuKbHddmtQ=";
  };

  propagatedBuildInputs = [ requests ];

  # No tests found
  doCheck = false;

  pythonImportsCheck = [ "trovoApi" ];

  meta = with lib; {
    description = "A Python wrapper for the Trovo API";
    homepage = "https://codeberg.org/wolfangaukang/python-trovo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
