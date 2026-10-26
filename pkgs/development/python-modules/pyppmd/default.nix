{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  setuptools,
  setuptools-scm,
  hypothesis,
  pytest-benchmark,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyppmd";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "miurahr";
    repo = "pyppmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0t1vyVMtmhb38C2teJ/Lq7dx4usm4Bzx+k7Zalf/nXE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-benchmark
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [
    "pyppmd"
  ];

  meta = {
    description = "PPMd compression/decompression library";
    homepage = "https://codeberg.org/miurahr/pyppmd";
    changelog = "https://codeberg.org/miurahr/pyppmd/src/tag/v${finalAttrs.version}/Changelog.rst#v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pitkling
      PopeRigby
    ];
  };
})
