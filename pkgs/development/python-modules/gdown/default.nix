{ lib
, beautifulsoup4
, buildPythonPackage
, fetchPypi
, filelock
, requests
, tqdm
, setuptools
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gdown";
  version = "4.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NH8jdpZ5qvfvpz5WVScPzajKVr5l64Skoh0UOYlUEEU=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    filelock
    requests
    tqdm
    setuptools
    six
  ] ++ requests.optional-dependencies.socks;

  checkPhase = ''
    $out/bin/gdown --help > /dev/null
  '';

  pythonImportsCheck = [
    "gdown"
  ];

  meta = with lib; {
    description = "A CLI tool for downloading large files from Google Drive";
    homepage = "https://github.com/wkentaro/gdown";
    changelog = "https://github.com/wkentaro/gdown/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
