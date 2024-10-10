{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  fs,
}:

buildPythonPackage rec {
  pname = "pyfatfs";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nathanhi";
    repo = "pyfatfs";
    rev = "v${version}";
    hash = "sha256-26b4EV3WERUqJ10VkYov3PDFhSBcfxCF79P8Eg5xpoM=";
  };

  doCheck = false;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];
  propagatedBuildInputs = [ fs ];

  postPatch = ''
    substituteInPlace ./pyproject.toml \
       --replace-fail 'setuptools ~= 67.8' setuptools \
       --replace-fail '"setuptools_scm[toml] ~= 7.1"' ""
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Python based FAT12/FAT16/FAT32 implementation with VFAT support";
    homepage = "https://github.com/nathanhi/pyfatfs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
