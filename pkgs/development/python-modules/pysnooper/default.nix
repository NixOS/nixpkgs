{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysnooper";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cool-RR";
    repo = "PySnooper";
    tag = version;
    hash = "sha256-+Cjqi0xkWO4QVAZymmcper4dal9pNWbpPgPY4UzbXfA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysnooper" ];

  meta = {
    description = "Poor man's debugger for Python";
    homepage = "https://github.com/cool-RR/PySnooper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seqizz ];
  };
}
