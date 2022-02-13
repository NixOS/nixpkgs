{ lib
, stdenv
, buildPythonPackage
, defusedxml
, deprecated
, fetchFromGitHub
, lxml
, paramiko
, psutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ospd";
  version = "21.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7" || stdenv.isDarwin;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dZgs+G2vJQIKnN9xHcNeNViG7mOIdKb+Ms2AKE+FC4M=";
  };

  propagatedBuildInputs = [
    defusedxml
    deprecated
    lxml
    paramiko
    psutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ospd"
  ];

  meta = with lib; {
    description = "Framework for vulnerability scanners which support OSP";
    homepage = "https://github.com/greenbone/ospd";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
