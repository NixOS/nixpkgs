{
  lib,
  buildPythonPackage,
  fetchPypi,
  pandoc,
  pytestCheckHook,
  requests,
  setuptools,
  publicsuffix-list,
}:

buildPythonPackage (finalAttrs: {
  pname = "publicsuffixlist";
  version = "1.0.2.20260211";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GNa+6TzEoy2G4xhCvl6lm9WvdDs0e4HAZPF6oBCc4PM=";
  };

  postPatch = ''
    rm publicsuffixlist/public_suffix_list.dat
    ln -s ${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat publicsuffixlist/public_suffix_list.dat
  '';

  build-system = [ setuptools ];

  optional-dependencies = {
    update = [ requests ];
    readme = [ pandoc ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "publicsuffixlist" ];

  enabledTestPaths = [ "publicsuffixlist/test.py" ];

  meta = {
    description = "Public Suffix List parser implementation";
    homepage = "https://github.com/ko-zu/psl";
    changelog = "https://github.com/ko-zu/psl/blob/v${finalAttrs.version}-gha/CHANGES.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "publicsuffixlist-download";
  };
})
