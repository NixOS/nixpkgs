{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyusb,
  influxdb-client,
  pyserial,
  pytestCheckHook,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "openant-unstable";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "openant";
    tag = "v${version}";
    hash = "sha256-YIROOAd68sNXRNJp+0qzUKJ9H2XTdhA/XUXP83AQr5U=";
  };

  nativeBuildInputs = [
    setuptools
    udevCheckHook
  ];

  postInstall = ''
    install -dm755 "$out/etc/udev/rules.d"
    install -m644 resources/42-ant-usb-sticks.rules "$out/etc/udev/rules.d/99-ant-usb-sticks.rules"
  '';

  propagatedBuildInputs = [ pyusb ];

  optional-dependencies = {
    serial = [ pyserial ];
    influx = [ influxdb-client ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "openant" ];

  meta = {
    homepage = "https://github.com/Tigge/openant";
    description = "ANT and ANT-FS Python Library";
    mainProgram = "openant";
    license = lib.licenses.mit;
  };
}
