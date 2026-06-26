{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  py-radix,
  versionCheckHook,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aggregate6";
  version = "1.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "job";
    repo = "aggregate6";
    rev = version;
    hash = "sha256-GXIZ2aNZUeiVkhmo2jdwIEk9jL/in2KuuKgi//TQGq0=";
  };

  build-system = [ setuptools ];

  dependencies = [ py-radix ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "aggregate6" ];
  versionCheckProgramArg = "-V";

  meta = {
    description = "IPv4 and IPv6 prefix aggregation tool";
    mainProgram = "aggregate6";
    homepage = "https://github.com/job/aggregate6";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ marcel ];
  };
}
