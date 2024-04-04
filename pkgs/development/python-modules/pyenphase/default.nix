{ lib
, awesomeversion
, buildPythonPackage
, envoy-utils
, fetchFromGitHub
, httpx
, lxml
, orjson
, poetry-core
, pyjwt
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, respx
, syrupy
, tenacity
}:

buildPythonPackage rec {
  pname = "pyenphase";
  version = "1.20.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "pyenphase";
    repo = "pyenphase";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bxwd8qHsvq9BuBMSu5JI/Yk/KC5aQ7b7lnXuIoNQ6EI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=pyenphase --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    awesomeversion
    envoy-utils
    httpx
    lxml
    orjson
    pyjwt
    tenacity
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
    syrupy
  ];

  disabledTests = [
    # https://github.com/pyenphase/pyenphase/issues/97
    "test_with_7_x_firmware"
  ];

  pythonImportsCheck = [
    "pyenphase"
  ];

  meta = with lib; {
    description = "Library to control enphase envoy";
    homepage = "https://github.com/pyenphase/pyenphase";
    changelog = "https://github.com/pyenphase/pyenphase/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
