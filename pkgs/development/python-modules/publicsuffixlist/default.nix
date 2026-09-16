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
  version = "1.0.2.20260916";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3J81nm0zgh7s9MhfvuaEuXv72DHz/jtAH5YhwCVY7w0=";
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
