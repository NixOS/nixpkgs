{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, requests
, requests-mock
, sseclient-py
}:

buildPythonPackage rec {
  pname = "pyarlo";
  version = "0.2.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-arlo";
    rev = version;
    sha256 = "0pp7y2llk4xnf6zh57j5xas0gw5zqm42qaqssd8p4qa3g5rds8k3";
  };

  propagatedBuildInputs = [
    requests
    sseclient-py
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    requests-mock
  ];

  pythonImportsCheck = [ "pyarlo" ];

  meta = with lib; {
    description = "Python library to work with Netgear Arlo cameras";
    homepage = "https://github.com/tchellomello/python-arlo";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
