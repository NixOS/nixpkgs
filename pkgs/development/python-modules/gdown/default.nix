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
  version = "4.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZFy1/3ZI+Zu/fZbOhswNoRlKFCUSXcPO/bJetSkiyHE=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    filelock
    requests
    tqdm
    setuptools
    six
  ];

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
