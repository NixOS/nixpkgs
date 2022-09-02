{ lib
, beautifulsoup4
, buildPythonApplication
, fetchPypi
, filelock
, requests
, tqdm
, setuptools
, six
}:

buildPythonApplication rec {
  pname = "gdown";
  version = "4.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ghcGEGPYr8qtnY4tVBD7wJicKz8JRqa9m/65RhYWzGo=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    filelock
    requests
    tqdm
    setuptools
    six
  ]
  ++ requests.optional-dependencies.socks;

  checkPhase = ''
    $out/bin/gdown --help > /dev/null
  '';

  pythonImportsCheck = [
    "gdown"
  ];

  meta = with lib; {
    description = "A CLI tool for downloading large files from Google Drive";
    homepage = "https://github.com/wkentaro/gdown";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
