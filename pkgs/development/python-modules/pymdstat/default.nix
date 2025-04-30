{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymdstat";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "pymdstat";
    rev = "v${version}";
    hash = "sha256-ifQZXc+it/UTltHc1ZL2zxJu7GvAxYzzmB4D+mCqEoE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pymdstat" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "unitest.py" ];

  meta = with lib; {
    description = "Pythonic library to parse Linux /proc/mdstat file";
    homepage = "https://github.com/nicolargo/pymdstat";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
