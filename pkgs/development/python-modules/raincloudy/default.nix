{
  lib,
  aiohttp,
  aioresponses,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage rec {
  pname = "raincloudy";
  version = "1.2.0";
  format = "setuptools";
  pypriject = true;

  # https://github.com/vanstinator/raincloudy/issues/65
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "vanstinator";
    repo = "raincloudy";
    rev = "refs/tags/${version}";
    hash = "sha256-qCkBVirM09iA1sXiOB9FJns8bHjQq7rRk8XbRWrtBDI=";
  };

  postPatch = ''
    # https://github.com/vanstinator/raincloudy/pull/60
    substituteInPlace setup.py \
      --replace-fail "bs4" "beautifulsoup4" \

    # fix raincloudy.aio package discovery, by relying on
    # autodiscovery instead.
    sed -i '/packages=/d' setup.py
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    requests
    beautifulsoup4
    urllib3
    html5lib
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "raincloudy"
    "raincloudy.aio"
  ];

  disabledTests = [
    # Test requires network access
    "test_attributes"
  ];

  meta = with lib; {
    description = "Module to interact with Melnor RainCloud Smart Garden Watering Irrigation Timer";
    homepage = "https://github.com/vanstinator/raincloudy";
    changelog = "https://github.com/vanstinator/raincloudy/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
