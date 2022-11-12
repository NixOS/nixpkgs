{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pythonOlder
, setuptools
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncio-mqtt";
  version = "0.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ByVslOx/XsxVan2/xdRi+wOQR9oVpIGtHPcHlIcHMEk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    paho-mqtt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  # Module will have tests starting with > 0.14.0
  doCheck = false;

  pythonImportsCheck = [
    "asyncio_mqtt"
  ];

  meta = with lib; {
    description = "Idomatic asyncio wrapper around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/asyncio-mqtt";
    license = licenses.bsd3;
    changelog = "https://github.com/sbtinstruments/asyncio-mqtt/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ hexa ];
  };
}
