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
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pjanuario";
    repo = "pyecoforest";
    rev = "refs/tags/v${version}";
    hash = "sha256-GBt7uHppWLq5nIIVwYsOWmLjWjcwdvJwDE/Gu2KnSIA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=pyecoforest --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
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
