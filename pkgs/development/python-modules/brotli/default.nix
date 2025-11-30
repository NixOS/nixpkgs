{
  lib,
  brotli,
  buildPythonPackage,
  fetchFromGitHub,
  pkgconfig,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    tag = "v${version}";
    hash = "sha256-ePfllKdY12hOPuO9uHuXFZ3Bdib6BLD4ghiaeurJZ28=";
    # .gitattributes is not correct or GitHub does not parse it correct and the archive is missing the test data
    forceFetchGit = true;
  };

  build-system = [
    pkgconfig
    setuptools
  ];

  # only returns information how to really build
  dontConfigure = true;

  env.USE_SYSTEM_BROTLI = 1;

  buildInputs = [
    brotli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "python/tests" ];

  meta = {
    changelog = "https://github.com/google/brotli/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/google/brotli";
    description = "Generic-purpose lossless compression algorithm";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
