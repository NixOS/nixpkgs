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
  version = "1.0.2.20250425";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kiz2MnUnrBLG6pNUtH73783gLUrOKYn4m3a12tFbOn4=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    update = [ requests ];
    readme = [ pandoc ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "publicsuffixlist" ];

  pytestFlagsArray = [ "publicsuffixlist/test.py" ];

  meta = with lib; {
    changelog = "https://github.com/ko-zu/psl/blob/v${version}-gha/CHANGES.md";
    description = "Public Suffix List parser implementation";
    homepage = "https://github.com/ko-zu/psl";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "publicsuffixlist-download";
  };
}
