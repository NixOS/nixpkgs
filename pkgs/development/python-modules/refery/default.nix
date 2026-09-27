{
  lib,
  buildPythonPackage,
  fetchPypi,

  poetry-core,
  pyyaml,
  colorama,
  junit-xml,
}:

buildPythonPackage rec {
  pname = "refery";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha512-ju0lqCSg0zcZNqRXDmFX6X1ugBocpmHMBWJApO6Tzhm/tLMQTKy2RpB4C8fkKCEWA2mYX4w1dLdHe68hZixwkQ==";
  };

  propagatedBuildInputs = [
    poetry-core
    pyyaml
    colorama
    junit-xml
  ];

  pythonImportsCheck = [ "refery" ];

  # No tests yet
  doCheck = false;

  meta = {
    description = "Functional testing tool";
    homepage = "https://github.com/RostanTabet/refery";
    mainProgram = "refery";
    maintainers = with lib.maintainers; [ rostan-t ];
    license = lib.licenses.mit;
  };
}
