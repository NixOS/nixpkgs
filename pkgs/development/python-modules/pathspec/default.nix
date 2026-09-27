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

buildPythonPackage (finalAttrs: {
  pname = "pathspec";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-F9tezVJBBKEg4XOBTJA2epapjQfEWy4QwvORn/+Rv1o=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "pathspec" ];

  nativeCheckInputs = [ unittestCheckHook ];

  passthru.tests = {
    inherit
      awsebcli
      black
      hatchling
      yamllint
      ;
  };

  __structuredAttrs = true;

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    changelog = "https://github.com/cpburnz/python-pathspec/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
})
