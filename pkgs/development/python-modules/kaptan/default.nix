{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EBMwpE/e3oiFhvMBC9FFwOxIpIBrxWQp+lSHpndAIfg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Configuration manager for python applications";
    mainProgram = "kaptan";
    homepage = "https://kaptan.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
