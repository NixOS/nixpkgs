{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  doit,
  configclass,
  mergedict,
  pytestCheckHook,
  hunspell,
  hunspellDicts,
}:

buildPythonPackage (finalAttrs: {
  pname = "doit-py";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pydoit";
    repo = "doit-py";
    rev = finalAttrs.version;
    hash = "sha256-DBl6/no04ZGRHHmN9gkEtBmAMgmyZWcfPCcFz0uxAv4=";
  };

  propagatedBuildInputs = [
    configclass
    doit
    mergedict
  ];

  nativeCheckInputs = [
    hunspell
    hunspellDicts.en_US
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disable linting checks
    "tests/test_pyflakes.py"
  ];

  pythonImportsCheck = [ "doitpy" ];

  meta = {
    description = "doit tasks for python stuff";
    homepage = "http://pythonhosted.org/doit-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
