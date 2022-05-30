{ lib
, buildPythonPackage
, fetchPypi
, pycryptodomex
, pythonOlder
, requests
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "gpsoauth";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c4d6a980625b8ab6f6f1cf3e30d9b10a6c61ababb2b60bfe4870649e9c82be0";
  };

  propagatedBuildInputs = [ pycryptodomex requests ];

  # upstream tests are not very comprehensive
  doCheck = false;

  pythonImportsCheck = [ "gpsoauth" ];

  meta = with lib; {
    description = "Library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };
}
