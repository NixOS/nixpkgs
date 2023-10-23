{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aiojobs";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/+PTHLrZyf2UuYkLWkNgzf9amFywDJnP2OKVWvARcAA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=aiojobs/ --cov=tests/" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
  ];

  pythonImportsCheck = [
    "aiojobs"
  ];

  meta = with lib; {
    description = "Jobs scheduler for managing background task (asyncio)";
    homepage = "https://github.com/aio-libs/aiojobs";
    changelog = "https://github.com/aio-libs/aiojobs/blob/v${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
