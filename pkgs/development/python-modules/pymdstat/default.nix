{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymdstat";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "pymdstat";
    rev = "v${version}";
    hash = "sha256-ZpAXD77bNJ+YpXCW0es7jR+Hs3uDDfxWVeHiWz3sDRs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pymdstat" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "unitest.py" ];

  meta = {
    description = "Pythonic library to parse Linux /proc/mdstat file";
    homepage = "https://github.com/nicolargo/pymdstat";
    maintainers = with lib.maintainers; [ rhoriguchi ];
    license = lib.licenses.mit;
  };
}
