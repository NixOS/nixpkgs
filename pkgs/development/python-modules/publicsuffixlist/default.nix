{
  lib,
  buildPythonPackage,
  fetchPypi,
  pandoc,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "publicsuffixlist";
  version = "1.0.2.20250906";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q2NaPMku1mwTHdhvi8xnWNcrBBXL7KOxMYd5g8cnWGU=";
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
