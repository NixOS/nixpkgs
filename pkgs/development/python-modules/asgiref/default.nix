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
  version = "3.3.4";
  pname = "asgiref";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "1rr76252l6p12yxc0q4k9wigg1jz8nsqga9c0nixy9q77zhvh9n2";
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
