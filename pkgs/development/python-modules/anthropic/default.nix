{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, poetry-core
, anyio
, distro
, httpx
, pydantic
, pytest-asyncio
, respx
, tokenizers
, typing-extensions
, pytestCheckHook
=======
, fetchPypi
, setuptools
, httpx
, importlib-metadata
, requests
, tokenizers
, aiohttp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "anthropic";
<<<<<<< HEAD
  version = "0.3.11";
=======
  version = "0.2.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-bjagT0I0/N76CGf1b8EBNyOTzPBWybr2I2yO5NWO3po=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    anyio
    distro
    httpx
    pydantic
    tokenizers
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  disabledTests = [
    "api_resources"
  ];
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2v3WF8eRIruXvFNjRRno3LoXt+dlpaI3LHf243RBJ+U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    httpx
    requests
    tokenizers
    aiohttp
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # try downloading tokenizer in tests
  # relates https://github.com/anthropics/anthropic-sdk-python/issues/24
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "anthropic"
  ];

  meta = with lib; {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
