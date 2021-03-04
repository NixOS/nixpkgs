{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aqualogic";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "swilson";
    repo = pname;
    rev = version;
    sha256 = "sha256-yxd+A5dsB9gBwVlPNjz+IgDHKTktNky84bWZMhA/xa4=";
  };

  propagatedBuildInputs = [ pyserial ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aqualogic" ];

  meta = with lib; {
    description = "Python library to interface with Hayward/Goldline AquaLogic/ProLogic pool controllers";
    homepage = "https://github.com/swilson/aqualogic";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
