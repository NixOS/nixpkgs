{
  buildPythonPackage,
  fetchFromGitHub,
  glib,
  lib,
  pygobject3,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gio-pyio";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmkohnen";
    repo = "gio-pyio";
    tag = finalAttrs.version;
    hash = "sha256-AwA2Yboa2P13/Ne4GtmBkX4x6Cq1J7SgufBOVZb1IMM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pygobject3 ];

  pythonImportsCheck = [ "gio_pyio" ];

  nativeCheckInputs = [
    glib
    pytestCheckHook
  ];

  meta = {
    description = "Python like IO for gio";
    homepage = "https://github.com/cmkohnen/gio-pyio";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
