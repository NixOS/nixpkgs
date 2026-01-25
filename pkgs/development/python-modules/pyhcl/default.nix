{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # pythonPackages
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhcl";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtuald";
    repo = "pyhcl";
    tag = version;
    hash = "sha256-djT0ao1WbM/sLKRycdA5J4IRu8NbmDayVKBdE4s6E2M=";
  };

  # https://github.com/virtuald/pyhcl/blob/51a7524b68fe21e175e157b8af931016d7a357ad/setup.py#L64
  configurePhase = ''
    echo '__version__ = "${version}"' > ./src/hcl/version.py
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "HCL is a configuration language. pyhcl is a python parser for it";
    mainProgram = "hcltool";
    homepage = "https://github.com/virtuald/pyhcl";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
