{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  netifaces,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  urllib3,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pydaikin";
  version = "2.13.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pydaikin";
    rev = "refs/tags/v${version}";
    hash = "sha256-t4SyFAgrLpXlDx464OHBWT8b+vGfIGZH6lKjX0k6tNw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    netifaces
    urllib3
    tenacity
  ];

  doCheck = false; # tests fail and upstream does not seem to run them either

  nativeCheckInputs = [
    freezegun
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydaikin" ];

  meta = with lib; {
    description = "Python Daikin HVAC appliances interface";
    homepage = "https://github.com/fredrike/pydaikin";
    changelog = "https://github.com/fredrike/pydaikin/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pydaikin";
  };
}
