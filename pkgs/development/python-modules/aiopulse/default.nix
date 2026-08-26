{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  psutil,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopulse";
  version = "0.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-acUcJM5ghUKezpYTncDADQTZa6NMyteG6Yu7GFPbuLs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    async-timeout
    psutil
  ];

  # Tests are not present
  doCheck = false;

  pythonImportsCheck = [ "aiopulse" ];

  meta = {
    description = "Python Rollease Acmeda Automate Pulse hub protocol implementation";
    longDescription = ''
      The Rollease Acmeda Pulse Hub is a WiFi hub that communicates with
      Rollease Acmeda Automate roller blinds via a proprietary RF protocol.
      This module communicates over a local area network using a proprietary
      binary protocol to issues commands to the Pulse Hub.
    '';
    homepage = "https://github.com/atmurray/aiopulse";
    changelog = "https://github.com/atmurray/aiopulse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
