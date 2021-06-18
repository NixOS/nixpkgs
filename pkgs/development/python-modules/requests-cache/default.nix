{ lib, buildPythonPackage, fetchPypi
, mock, requests, six, urllib3 }:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd9120a4ab7b8128cba9b6b120d8b5560d566a3cd0f828cced3d3fd60a42ec40";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ requests six urllib3 ];

  meta = with lib; {
    description = "Persistent cache for requests library";
    homepage = "https://pypi.python.org/pypi/requests-cache";
    license = licenses.bsd3;
  };
}
