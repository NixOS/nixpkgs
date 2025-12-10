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
  version = "1.0.2.20251209";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-37hj0A37m8BxNAWWIpRoromnXWJUbqvOOOu9iw01DKk=";
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
