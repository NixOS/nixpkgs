{ lib
, stdenv
, buildPythonPackage
, defusedxml
, deprecated
, fetchFromGitHub
, lxml
, paramiko
, poetry
, psutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ospd";
  version = "21.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.7" || stdenv.isDarwin;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i4nfvxgxibqmqb6jwih951960sm2zy00i1wnjfnwb6za1xkpbkp";
  };

  nativeBuildInputs = [
    poetry
  ];

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

  pythonImportsCheck = [ "ospd" ];

  meta = with lib; {
    description = "Framework for vulnerability scanners which support OSP";
    homepage = "https://github.com/greenbone/ospd";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
