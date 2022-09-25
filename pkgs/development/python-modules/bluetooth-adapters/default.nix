{ lib
, async-timeout
, bleak
, buildPythonPackage
, dbus-fast
, fetchFromGitHub
, myst-parser
, poetry-core
, pytestCheckHook
, pythonOlder
, sphinx-rtd-theme
, sphinxHook
}:

buildPythonPackage rec {
  pname = "bluetooth-adapters";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VjrKw1ljwOKdEqxX0iCIKUX9YB8cMlAuJzOarlxgfnQ=";
  };

  postPatch = ''
    # Drop pytest arguments (coverage, ...)
    sed -i '/addopts/d' pyproject.toml
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    myst-parser
    poetry-core
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    async-timeout
    bleak
    dbus-fast
  ];

  pythonImportsCheck = [
    "bluetooth_adapters"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/bluetooth-devices/bluetooth-adapters/blob/main/CHANGELOG.md";
    description = "Tools to enumerate and find Bluetooth Adapters";
    homepage = "https://bluetooth-adapters.readthedocs.io/";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
