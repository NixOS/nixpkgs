{ lib
, stdenv
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "3.4.1";
  pname = "asgiref";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "sha256-aXD46qH5sTTmp0rlzQGLAN+MfIz1u6obCwtfqoIYgBA=";
  };

  propagatedBuildInputs = [
    async-timeout
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  pythonImportsCheck = [ "asgiref" ];

  meta = with lib; {
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
