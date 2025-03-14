{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  setuptools-scm,
  fs,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pyfatfs";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nathanhi";
    repo = "pyfatfs";
    tag = "v${version}";
    hash = "sha256-26b4EV3WERUqJ10VkYov3PDFhSBcfxCF79P8Eg5xpoM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ fs ];

  postPatch = ''
    substituteInPlace ./pyproject.toml \
      --replace-fail 'setuptools ~= 67.8' setuptools \
      --replace-fail '"setuptools_scm[toml] ~= 7.1"' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Python based FAT12/FAT16/FAT32 implementation with VFAT support";
    homepage = "https://github.com/nathanhi/pyfatfs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
