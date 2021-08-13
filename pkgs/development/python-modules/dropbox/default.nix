{ lib, buildPythonPackage, fetchPypi
, pytest-runner, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99e84367d5b983815a3680eea2c7e67bff14637c4702010c5c58611eb714dfe2";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner == 5.2.0" "pytest-runner"
  '';

  # Set DROPBOX_TOKEN environment variable to a valid token.
  doCheck = false;

  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ requests urllib3 mock setuptools stone ];

  meta = with lib; {
    description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://www.dropbox.com/developers/core/docs";
    license = licenses.mit;
  };
}
