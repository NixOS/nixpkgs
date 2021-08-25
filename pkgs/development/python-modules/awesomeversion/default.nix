{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "21.8.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-j5y3f6F+8PzOPxpBHE3LKF3kdRzP4d21N/1Bd6v+MQg=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "main" ${version}
  '';

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "awesomeversion" ];

  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
