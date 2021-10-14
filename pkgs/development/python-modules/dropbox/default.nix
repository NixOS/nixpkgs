{ lib, buildPythonPackage, fetchPypi
, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a4697acfe95bea13af9c133a41a8d774946c58ab47083b4c82a017a1b08c380";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner == 5.2.0'," ""
  '';

  propagatedBuildInputs = [ requests urllib3 mock setuptools stone ];

  # Set DROPBOX_TOKEN environment variable to a valid token.
  doCheck = false;

  pythonImportsCheck = [ "dropbox" ];

  meta = with lib; {
    description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://www.dropbox.com/developers/core/docs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
