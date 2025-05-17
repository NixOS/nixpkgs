{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pyusb,
  influxdb-client,
  pyserial,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openant-unstable";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "openant";
    tag = "v${version}";
    hash = "sha256-XUPL2BJQnQNUX105d342TLiGI28kc+iZ6oRofO0VLjk=";
  };

  nativeBuildInputs = [ setuptools ];

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

  meta = with lib; {
    homepage = "https://github.com/Tigge/openant";
    description = "ANT and ANT-FS Python Library";
    mainProgram = "openant";
    license = licenses.mit;
  };
}
