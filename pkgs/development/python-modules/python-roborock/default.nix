{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, click
, construct
, dacite
, fetchFromGitHub
, paho-mqtt
, poetry-core
, pycryptodome
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-roborock";
  version = "0.17.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "humbertogontijo";
    repo = "python-roborock";
    rev = "refs/tags/v${version}";
    hash = "sha256-lDSIed+/n/3D2kI44FcTbcTl9xAl+EbCPGrhfN5q4JE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    click
    construct
    dacite
    paho-mqtt
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "roborock"
  ];

  meta = with lib; {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/humbertogontijo/python-roborock";
    changelog = "https://github.com/humbertogontijo/python-roborock/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
