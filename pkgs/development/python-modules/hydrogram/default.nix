{
  lib,
  aiosqlite,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  hatchling,
  pyaes,
  pysocks,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hydrogram";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hydrogram";
    repo = "hydrogram";
    tag = "v${version}";
    hash = "sha256-QpweUDCypTxOOWL08gCUuMgbuE4130iNyxRpUNuSBac=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-async-in-test.patch";
      excludes = [ ".github/workflows/code-style.yml" ];
      url = "https://github.com/hydrogram/hydrogram/commit/7431319a1d990aa838012bd566a9746da7df2a6e.patch";
      hash = "sha256-MPv13cxnNPDD+p9EPjDPFqydGy57oXzLeRxL3lG8JKU=";
    })
  ];

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
    changelog = "https://github.com/hydrogram/hydrogram/releases/tag/${src.tag}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ tholo ];
  };
}
