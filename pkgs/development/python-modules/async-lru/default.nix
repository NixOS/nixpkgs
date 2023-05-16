{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "async-lru";
<<<<<<< HEAD
  version = "2.0.4";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-S2sOkgtS+YdMtVP7UHD3+oR8Fem8roLhhgVVfh33PcM=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [
=======
    rev = "v${version}";
    hash = "sha256-kcvtF/p1L5OVXJSRxRQ0NMFtV29tAysZs8cnTHqOBOo=";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    typing-extensions
  ];

  postPatch = ''
    sed -i -e '/^addopts/d' -e '/^filterwarnings/,+2d' setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = with lib; {
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
