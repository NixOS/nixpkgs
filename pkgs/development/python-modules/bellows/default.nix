{ lib
, buildPythonPackage
, click
, click-log
, fetchFromGitHub
, pure-pcapy3
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.38.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = "refs/tags/${version}";
    hash = "sha256-7aqzhujTn1TMYBA6+79Ok76yv8hXszuuZ7TjhJ6zbQw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    click
    click-log
    pure-pcapy3
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [
    "bellows"
  ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
