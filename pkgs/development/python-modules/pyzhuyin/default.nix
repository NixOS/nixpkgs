{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzhuyin";
  version = "0.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-S8xht5BSZj/g2ny47N/kPEt0iEGLHf9MrDhEnfiIEdQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "pyzhuyin"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Phonetic and Pinyin conversion tool";
    homepage = "https://pypi.org/project/pyzhuyin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vherrmann ];
  };
})
