{ lib, buildPythonPackage, fetchFromGitHub
, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.22.0";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dropbox-sdk-python";
    rev = "v${version}";
    sha256 = "0fhzpss3zs5x3hr4amrmw8hras75qc385ikpw0sx5a907kigk7w5";
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
