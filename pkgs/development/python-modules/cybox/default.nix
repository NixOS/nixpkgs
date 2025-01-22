{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lxml,
  mixbox,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cybox";
  version = "2.1.0.21";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CybOXProject";
    repo = "python-cybox";
    tag = "v${version}";
    hash = "sha256-Gn/gH7pvvOqLIGExgCNa5KswPazIZUZXdQe3LRAUVjw=";
  };

  patches = [
    # Import ABC from collections.abc for Python 3 compatibility, https://github.com/CybOXProject/python-cybox/pull/332
    (fetchpatch {
      name = "collections-abc.patch";
      url = "https://github.com/CybOXProject/python-cybox/commit/fd4631dac12943d89e9ea2e94105cbc3b81d52f9.patch";
      hash = "sha256-dXEsJujtbU/SuUBge8abWgMPeYO1ZR3c5758Bd0dnwE=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    lxml
    mixbox
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cybox" ];

  meta = {
    description = "Library for parsing, manipulating, and generating CybOX content";
    homepage = "https://github.com/CybOXProject/python-cybox/";
    changelog = "https://github.com/CybOXProject/python-cybox/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
