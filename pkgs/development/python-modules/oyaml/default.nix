{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # pythonPackages
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage {
  pname = "oyaml";
  version = "unstable-2021-12-03";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "oyaml";
    rev = "d0195070d26bd982f1e4e604bded5510dd035cd7";
    hash = "sha256-1rSEhiULlAweLDqUFX+JBFxe3iW9kNlRA2zjcG8MYSg=";
  };

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oyaml" ];

  meta = {
    description = "Drop-in replacement for PyYAML which preserves dict ordering";
    homepage = "https://github.com/wimglenn/oyaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
