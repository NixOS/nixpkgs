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
  version = "4.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bL991BCFiMc0qliBMdjh1S5k8Ic4cPcfdMusGV8MYO8=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
