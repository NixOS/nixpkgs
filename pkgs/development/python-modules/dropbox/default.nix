{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, urllib3
, mock
, setuptools
, stone
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.27.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dropbox-sdk-python";
    rev = "v${version}";
    sha256 = "sha256-atIrrK4BgTfu0UaHTqJ66AxEeSJLanrmYx8myrOCOfo=";
  };

  propagatedBuildInputs = [
    requests
    urllib3
    mock
    setuptools
    stone
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner == 5.2.0'," ""
  '';

  # Set DROPBOX_TOKEN environment variable to a valid token.
  doCheck = false;

  pythonImportsCheck = [
    "dropbox"
  ];

  meta = with lib; {
    description = "Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://github.com/dropbox/dropbox-sdk-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
