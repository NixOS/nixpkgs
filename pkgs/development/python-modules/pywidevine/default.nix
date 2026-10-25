{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pycryptodome,
  protobuf,
  requests,
  pyyaml,
  unidecode,
  click,
  pymp4,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywidevine";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Z0La9f15fFpIE+sTAO+zGB/83dDIxHjuKMfFNqoOUbI=";
  };

  patches = [
    ./construct-2.10-compatibility.patch
  ];

  build-system = [ poetry-core ];

  dependencies = [
    click
    protobuf
    pycryptodome
    pymp4
    pyyaml
    requests
    unidecode
  ];

  pythonImportsCheck = [ "pywidevine" ];

  meta = {
    description = "Python implementation of Google's Widevine CDM";
    homepage = "https://github.com/devine-dl/pywidevine";
    changelog = "https://github.com/devine-dl/pywidevine/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bdim404 ];
    mainProgram = "pywidevine";
  };
})
