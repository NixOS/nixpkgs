{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "find-libpython";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ktbarrett";
    repo = "find_libpython";
    tag = "v${version}";
    hash = "sha256-6VRUkRACtZt8n2VT5MwxZ51/ep+Lt/jmEGyfI1zseJw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "find_libpython" ];

  meta = with lib; {
    description = "Finds the libpython associated with your environment, wherever it may be hiding";
    mainProgram = "find_libpython";
    changelog = "https://github.com/ktbarrett/find_libpython/releases/tag/v${version}";
    homepage = "https://github.com/ktbarrett/find_libpython";
    license = licenses.mit;
    maintainers = with maintainers; [ jleightcap ];
  };
}
