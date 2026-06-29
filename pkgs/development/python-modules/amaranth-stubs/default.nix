{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,

  amaranth,

  setuptools,
  setuptools-scm,
}:
buildPythonPackage (finalAttrs: {
  pname = "amaranth_stubs";
  version = "0.5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kuznia-rdzeni";
    repo = "amaranth-stubs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tpZH1Wrl+03AheS3OA8m3NpWQygfqn1GMIfmwkpdyos=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    amaranth
  ];

  # doCheck = false;

  meta = {
    description = "Typing stubs for Amaranth HDL, intended for use with Pyright";
    homepage = "https://github.com/kuznia-rdzeni/amaranth-stubs/";
    downloadPage = "https://pypi.org/project/amaranth-stubs/#amaranth_stubs-0.5.0.0.tar.gz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bigflipbot ];
    platforms = lib.platforms.linux;
  };
})
