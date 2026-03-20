{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libcec,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycec";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "konikvranik";
    repo = "pycec";
    tag = "v${version}";
    hash = "sha256-5KQyHjAvHWeHFqcFHFJxDOPwWuVcFAN2wVdz9a77dzU=";
  };

  patches = [
    # https://github.com/konikvranik/pyCEC/pull/84
    ./python-3.14-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ libcec ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycec" ];

  meta = {
    description = "Python modules to access HDMI CEC devices";
    mainProgram = "pycec";
    homepage = "https://github.com/konikvranik/pycec/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
