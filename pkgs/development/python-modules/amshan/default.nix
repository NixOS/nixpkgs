{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  construct,
  paho-mqtt,
  pyserial-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "amshan";
  version = "2021.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "toreamun";
    repo = "amshan";
    tag = version;
    hash = "sha256-eL8YzQB6Vj4l3cYFgWve88vLojvcxMtr2xvTUKT+Ekk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    construct
    paho-mqtt
    pyserial-asyncio
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "han" ];

  meta = {
    description = "Decode smart power meter data stream of Cosem HDLC frames used by MBUS";
    longDescription = ''
      The package has special support of formats for Aidon, Kaifa and Kamstrup
      meters used in Norway and Sweden (AMS HAN).
    '';
    homepage = "https://github.com/toreamun/amshan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
