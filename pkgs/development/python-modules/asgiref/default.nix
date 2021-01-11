{ stdenv
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, lib
}:

buildPythonPackage rec {
  version = "3.3.1";
  pname = "asgiref";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "00r4l9x425wkbac6b6c2ksm2yjinrvvdf0ajizrzq32h0jg82016";
  };

  propagatedBuildInputs = [ async-timeout ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  meta = with lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = "https://github.com/django/asgiref";
  };
}
