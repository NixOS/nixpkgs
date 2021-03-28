{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, requests
, responses
, urllib3
}:

buildPythonPackage rec {
  pname = "amcrest";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-amcrest";
    rev = version;
    sha256 = "06gbrshf6vqvq3k813d1w37k2kmps0g6msa4lp2f9xvzw3iczshy";
  };

  propagatedBuildInputs = [
    argcomplete
    requests
    urllib3
  ];

  checkInputs = [
    mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "amcrest" ];

  meta = with lib; {
    description = "Python module for Amcrest and Dahua Cameras";
    homepage = "https://github.com/tchellomello/python-amcrest";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
