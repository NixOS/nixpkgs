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
  version = "2.0.3";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    rev = "refs/tags/v${version}";
    hash = "sha256-5NlcufnCqcB8k8nscFJGwlpEbDJG5KAEwWBat5dvI84=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [
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
