{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lz4,
  pyelftools,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygbl";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "pygbl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FjtO0J8syPi3KWmumpKrG191mtkFw6dCdlAvRqzuQQI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    pyelftools
  ];

  optional-dependencies = lib.fix (self: {
    crypto = [ cryptography ];
    lz4 = [ lz4 ];
    all = self.crypto ++ self.lz4;
  });

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  meta = {
    changelog = "https://github.com/zigpy/pygbl/releases/tag/${finalAttrs.src.tag}";
    description = "Parser for Silicon Labs GBL and EBL firmware images";
    homepage = "https://github.com/zigpy/pygbl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
