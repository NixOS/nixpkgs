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

buildPythonPackage rec {
  pname = "publicsuffixlist";
  version = "1.0.2.20251209";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-37hj0A37m8BxNAWWIpRoromnXWJUbqvOOOu9iw01DKk=";
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
    changelog = "https://github.com/ko-zu/psl/blob/v${version}-gha/CHANGES.md";
    description = "Public Suffix List parser implementation";
    homepage = "https://github.com/ko-zu/psl";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "publicsuffixlist-download";
  };
}
