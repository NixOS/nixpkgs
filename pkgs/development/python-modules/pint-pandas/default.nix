{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  wheel,
  pint,
  pandas,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pint-pandas";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint-pandas";
    tag = version;
    hash = "sha256-B8nxGetnYpA+Nuhe//D8n+5g7rPO90Mm1iWswJ0+mPc=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    pint
    pandas
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pandas support for pint";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint-pandas";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
