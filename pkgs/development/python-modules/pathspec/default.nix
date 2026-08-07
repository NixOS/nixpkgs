{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  unittestCheckHook,

  # for passthru.tests
  awsebcli,
  black,
  hatchling,
  yamllint,
}:

buildPythonPackage rec {
  pname = "pathspec";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F9tezVJBBKEg4XOBTJA2epapjQfEWy4QwvORn/+Rv1o=";
  };

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "pathspec" ];

  checkInputs = [ unittestCheckHook ];

  passthru.tests = {
    inherit
      awsebcli
      black
      hatchling
      yamllint
      ;
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    changelog = "https://github.com/cpburnz/python-pathspec/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
