{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  nix-update-script,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzhuyin";
  version = "0.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rku1999";
    repo = "python-zhuyin";
    rev = "82c31bb89871e7567853406471c5849a9c2034f1";
    hash = "sha256-xFY3Eww1i3n+4oCD2ZEVBCLcGNaX8bC0wS6ayXsPpcY=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pyzhuyin"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Phonetic and Pinyin conversion tool";
    homepage = "https://pypi.org/project/pyzhuyin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vherrmann ];
  };
})
