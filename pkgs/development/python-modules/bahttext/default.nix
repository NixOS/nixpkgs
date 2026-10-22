{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "bahttext";
  version = "1.0.2-unstable-2020-05-31";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sekz";
    repo = "bahttext";
    rev = "5dc3a6e9056a81cefb199c49ca69f9a7a9fa835b";
    hash = "sha256-q/z64c5Nqq0PbUGBzyODQchTs2bV9ksujCMLB8ZCB/Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "bahttext" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Convert currency numbers to Thai Baht text";
    homepage = "https://github.com/sekz/bahttext";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };
})
