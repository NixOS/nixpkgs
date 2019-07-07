{ stdenv, buildPythonPackage, fetchPypi
, mock, requests, six, urllib3 }:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18jpyivnq5pjbkymk3i473rihpj2bgikafpha7xvr6w736hiqmpy";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ requests six urllib3 ];

  meta = with stdenv.lib; {
    description = "Persistent cache for requests library";
    homepage = https://pypi.python.org/pypi/requests-cache;
    license = licenses.bsd3;
  };
}
