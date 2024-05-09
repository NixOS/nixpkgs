{ lib
, buildPythonPackage
, fetchPypi
, httplib2
}:

buildPythonPackage rec {
  pname = "python-pipedrive";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f8qiyl82bpwxwjw2746vdvkps2010mvn1x9b6j6ppmifff2d4pl";
  };

  propagatedBuildInputs = [ httplib2 ];

  doCheck = false; # Tests are not provided.

  meta = with lib; {
    description = "Python library for interacting with the pipedrive.com API";
    homepage = "https://github.com/jscott1989/python-pipedrive";
    license = licenses.unfree;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
