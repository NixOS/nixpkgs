{
  lib,
  aiosqlite,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyaes,
  pysocks,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hydrogram";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hydrogram";
    repo = "hydrogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-kKzXR8ared2+mHBABxtX+glJ3PMuxA1Pek3DuUkTT40=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyaes
    pysocks
    aiosqlite
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "hydrogram"
    "hydrogram.errors"
    "hydrogram.types"
  ];

  meta = with lib; {
    description = "Asynchronous Telegram MTProto API framework for fluid user and bot interactions";
    homepage = "https://github.com/hydrogram/hydrogram";
    changelog = "https://github.com/hydrogram/hydrogram/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ tholo ];
  };
}
