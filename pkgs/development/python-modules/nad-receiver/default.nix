{ lib
, pyserial
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nad-receiver";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "joopert";
    repo = "nad_receiver";
    rev = version;
    sha256 = "sha256-jRMk/yMA48ei+g/33+mMYwfwixaKTMYcU/z/VOoJbvY=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nad_receiver" ];

  meta = with lib; {
    description = "Python interface for NAD receivers";
    homepage = "https://github.com/joopert/nad_receiver";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
