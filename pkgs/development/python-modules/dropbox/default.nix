{ lib, buildPythonPackage, fetchPypi
, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aa351ec8bbb11cf3560e731b81d25f39c7edcb5fa92c06c5d68866cb9f90d54";
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
