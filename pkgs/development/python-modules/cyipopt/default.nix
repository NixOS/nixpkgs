{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  ipopt,
  numpy,
  pkg-config,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cyipopt";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mechmotum";
    repo = "cyipopt";
    rev = "v${version}";
    hash = "sha256-ddiSCVzywlCeeVbRJg2wxKIlAVlZw9Js95IbEDqhh5Q=";
  };

  nativeBuildInputs = [
    pkg-config
    pytestCheckHook
  ];

  buildInputs = [ ipopt ];

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "cyipopt" ];

  meta = {
    description = "Cython interface for the interior point optimzer IPOPT";
    homepage = "https://github.com/mechmotum/cyipopt";
    changelog = "https://github.com/mechmotum/cyipopt/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
