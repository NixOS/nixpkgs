{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, respx
}:

buildPythonPackage rec {
  pname = "pyecoforest";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pjanuario";
    repo = "pyecoforest";
    rev = "refs/tags/v${version}";
    hash = "sha256-C8sFq0vsVsq6irWbRd0eq18tfKu0qRRBZHt23CiDTGU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=pyecoforest --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "pyecoforest"
  ];

  meta = with lib; {
    description = "Module for interacting with Ecoforest devices";
    homepage = "https://github.com/pjanuario/pyecoforest";
    changelog = "https://github.com/pjanuario/pyecoforest/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
