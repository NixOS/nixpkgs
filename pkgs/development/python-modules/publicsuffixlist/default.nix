{
  lib,
  buildPythonPackage,
  fetchPypi,
  pandoc,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "publicsuffixlist";
  version = "1.0.2.20251030";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vEQp18br81UIBQtfVW8XAsR3i9iMhTiPtDKQqyJhW9w=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    update = [ requests ];
    readme = [ pandoc ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "publicsuffixlist" ];

  enabledTestPaths = [ "publicsuffixlist/test.py" ];

  meta = with lib; {
    changelog = "https://github.com/ko-zu/psl/blob/v${version}-gha/CHANGES.md";
    description = "Public Suffix List parser implementation";
    homepage = "https://github.com/ko-zu/psl";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "publicsuffixlist-download";
  };
}
