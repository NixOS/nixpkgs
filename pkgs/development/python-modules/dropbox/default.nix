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
  version = "11.26.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dropbox-sdk-python";
    rev = "v${version}";
    sha256 = "0ncx41jg2wbsklqkrh0zjwjs3kfkscz8d6gcbsxqa1qpa3pa5519";
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
