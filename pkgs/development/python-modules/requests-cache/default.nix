{ stdenv, buildPythonPackage, fetchPypi
, mock, requests, six, urllib3 }:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ requests six urllib3 ];

  meta = with stdenv.lib; {
    description = "Persistent cache for requests library";
    homepage = https://pypi.python.org/pypi/requests-cache;
    license = licenses.bsd3;
  };
}
