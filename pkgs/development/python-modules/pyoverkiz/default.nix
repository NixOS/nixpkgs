{ lib
, aiohttp
, attrs
, backoff
<<<<<<< HEAD
, backports-strenum
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, boto3
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyhumps
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, warrant-lite
}:

buildPythonPackage rec {
  pname = "pyoverkiz";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.7.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iMicknl";
    repo = "python-overkiz-api";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-tb0xU1H1VrWTuObCg1+mFkzawAzrknO3fER7cN2St7U=";
=======
    hash = "sha256-DZ9MpwlZvq6LHbvnesk7XtGsHOhZvc1tXb/xVDQuR48=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pyhumps = "^3.0.2,!=3.7.3"' 'pyhumps = "^3.0.2"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiohttp
    attrs
    backoff
    backports-strenum
    boto3
    pyhumps
=======
    attrs
    aiohttp
    backoff
    pyhumps
    boto3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    warrant-lite
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyoverkiz"
  ];

  meta = with lib; {
    description = "Module to interact with the Somfy TaHoma API or other OverKiz APIs";
    homepage = "https://github.com/iMicknl/python-overkiz-api";
    changelog = "https://github.com/iMicknl/python-overkiz-api/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
