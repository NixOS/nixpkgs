{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, httpx
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, respx
}:

buildPythonPackage rec {
  pname = "pywaze";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "pywaze";
    rev = "refs/tags/v${version}";
    hash = "sha256-n5W8TdZZJmT7SECXE8k6WK2lmCcucA6eLm+LZpojERo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov --cov-report term-missing --cov=src/pywaze " ""
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "pywaze"
  ];

  meta = with lib; {
    description = "Module for calculating WAZE routes and travel times";
    homepage = "https://github.com/eifinger/pywaze";
    changelog = "https://github.com/eifinger/pywaze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
