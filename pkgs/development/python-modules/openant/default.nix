{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, pyusb
, influxdb-client
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openant-unstable";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "openant";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ook9dwcyWvpaGylVDjBxQ2bnXRUBPYQHo6Wub+ISpwE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postInstall = ''
    install -dm755 "$out/etc/udev/rules.d"
    install -m644 resources/42-ant-usb-sticks.rules "$out/etc/udev/rules.d/99-ant-usb-sticks.rules"
  '';

  propagatedBuildInputs = [ pyusb ];

  passthru.optional-dependencies = {
    serial = [
      pyserial
    ];
    influx = [
      influxdb-client
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "openant"
  ];

  meta = with lib; {
    homepage = "https://github.com/Tigge/openant";
    description = "ANT and ANT-FS Python Library";
    license = licenses.mit;
  };

}
