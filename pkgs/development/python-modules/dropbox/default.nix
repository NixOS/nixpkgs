{ lib, buildPythonPackage, fetchPypi
, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab84c9c78606faa0dc94cdb95c6b2bdb579beb5f34fff42091c98a1e0fbeb16c";
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
