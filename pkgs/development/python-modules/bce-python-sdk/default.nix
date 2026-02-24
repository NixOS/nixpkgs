{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  future,
  pycryptodome,
  six,
}:

let
  version = "0.9.46";
in
buildPythonPackage {
  pname = "bce-python-sdk";
  inherit version;
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "bce_python_sdk";
    inherit version;
    hash = "sha256-S/AbIubRcszZSqIB+LxvKpjQ2keEFg53z6z8xxwmhr4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    future
    pycryptodome
    six
  ];

  pythonImportsCheck = [ "baidubce" ];

  meta = {
    description = "Baidu Cloud Engine SDK for python";
    homepage = "https://github.com/baidubce/bce-sdk-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
