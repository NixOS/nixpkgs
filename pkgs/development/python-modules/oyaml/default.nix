{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # pythonPackages
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "oyaml";
  version = "unstable-2021-12-03";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "oyaml";
    rev = "d0195070d26bd982f1e4e604bded5510dd035cd7";
    hash = "sha256-1rSEhiULlAweLDqUFX+JBFxe3iW9kNlRA2zjcG8MYSg=";
  };

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oyaml" ];

  meta = with lib; {
    description = "Drop-in replacement for PyYAML which preserves dict ordering";
    homepage = "https://github.com/wimglenn/oyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
