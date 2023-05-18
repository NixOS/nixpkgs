{ lib
, buildPythonPackage
, fetchFromGitHub
, filelock
, lxml
, pycryptodomex
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  pname = "blobfile";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "christopher-hesse";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vVoiNIN/LNdbedaOQ+gtj4jhzmrGri49fftHKG+K/fg=";
  };

  propagatedBuildInputs = [
    pycryptodomex
    filelock
    urllib3
    lxml
  ];

  # Tests require a running Docker instance
  doCheck = false;

  pythonImportsCheck = [
    "blobfile"
  ];

  meta = with lib; {
    description = "Read Google Cloud Storage, Azure Blobs, and local paths with the same interface";
    homepage = "https://github.com/christopher-hesse/blobfile";
    changelog = "https://github.com/christopher-hesse/blobfile/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
