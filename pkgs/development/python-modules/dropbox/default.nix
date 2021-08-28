{ lib, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools, stone }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ba43384029424779a4b3ec8d5832362c5c0f37cd644be2fb87e2b30a569849e";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner == 5.2.0" "pytest-runner"
  '';

  # Set DROPBOX_TOKEN environment variable to a valid token.
  doCheck = false;

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ requests urllib3 mock setuptools stone ];

  meta = with lib; {
    description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://www.dropbox.com/developers/core/docs";
    license = licenses.mit;
  };
}
