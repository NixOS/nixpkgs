{ lib
, aiohttp
, aresponses
, awesomeversion
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-homewizard-energy";
  version = "2.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XTSnIL/hBL1Rsyv/tBce/WCvA3n7mZern0v3i6gTOeA=";
  };

  patches = [
    # https://github.com/DCSBL/python-homewizard-energy/pull/235
    (fetchpatch {
      name = "remove-setuptools-dependency.patch";
      url = "https://github.com/DCSBL/python-homewizard-energy/commit/b006b0bc1f3d0b4a7569654a1afa90dd4cffaf18.patch";
      hash = "sha256-WQeepxiYnBfFcQAmrc3pavBz5j1Qo0HmUcOxsK/pr50=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    awesomeversion
    aiohttp
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "homewizard_energy"
  ];

  meta = with lib; {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/DCSBL/python-homewizard-energy";
    changelog = "https://github.com/DCSBL/python-homewizard-energy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
