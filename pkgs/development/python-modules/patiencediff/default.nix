{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.14";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KTOESjaj8fMxJZ7URqg6UMpiQppqZAlk4IPWEw4/Nvw=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patiencediff" ];

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    mainProgram = "patiencediff";
    homepage = "https://github.com/breezy-team/patiencediff";
    changelog = "https://github.com/breezy-team/patiencediff/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wildsebastian ];
  };
}
