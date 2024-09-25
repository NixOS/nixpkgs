{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, requests
}:

buildPythonPackage rec {
  pname = "py-opensonic";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    rev = "v${version}";
    hash = "sha256-wXTXuX+iIMEoALxsciopucmvBxAyEeiOgjJPrbD63gM=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "libopensonic"
  ];

  meta = with lib; {
    description = "Python library to wrap the Open Subsonic REST API";
    homepage = "https://github.com/khers/py-opensonic";
    changelog = "https://github.com/khers/py-opensonic/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
