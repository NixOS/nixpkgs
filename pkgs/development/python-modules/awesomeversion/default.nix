{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "20.12.5";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "1jwlfqnrqlxjp30fj9bcqh7vgicmpdbn5kjdcmll4srnl87lalfg";
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
