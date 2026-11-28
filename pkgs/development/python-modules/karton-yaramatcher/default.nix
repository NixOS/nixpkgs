{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  karton-core,
  unittestCheckHook,
  yara-python,
}:

buildPythonPackage (finalAttrs: {
  pname = "karton-yaramatcher";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-yaramatcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-URGW8FyJZ3ktrwolls5ElSWn8FD6vWCA+Eu0aGtPh6U=";
  };

  patches = [
    # Modernize to karton v6.1.0
    (fetchpatch2 {
      name = "modernize.patch";
      url = "https://github.com/CERT-Polska/karton-yaramatcher/commit/b56f8382f119ee94fdff9e7fbb63e2f5e685c801.patch";
      hash = "sha256-NMVYMMWa/YTqRsq4KZbsJzuIMW41F1O3EaeEaAqd2c0=";
      includes = [ "karton/yaramatcher/yaramatcher.py" ];
    })
  ];

  pythonRelaxDeps = [ "karton-core" ];

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.yaramatcher" ];

  meta = {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    mainProgram = "karton-yaramatcher";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    changelog = "https://github.com/CERT-Polska/karton-yaramatcher/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
