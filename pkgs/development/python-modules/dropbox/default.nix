{ lib, buildPythonPackage, fetchPypi
, pytest-runner, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14dd51e0e3981cb81384a8e13a308de0df13c7c4b6ba7f080177ede947761cbb";
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
