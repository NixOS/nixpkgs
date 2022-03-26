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
  version = "3.5.0";
  pname = "asgiref";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "sha256-eWDsd8iWK1C/X3t/fKAM1i4hyTM/daGTd8CDSgDTL/U=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
