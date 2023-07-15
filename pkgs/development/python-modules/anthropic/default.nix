{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, httpx
, importlib-metadata
, requests
, tokenizers
, aiohttp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.2.10";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5NoGGobY/7hgcsCw/q8hmjpPff3dQiTfm6dp5GlJjBk=";
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
