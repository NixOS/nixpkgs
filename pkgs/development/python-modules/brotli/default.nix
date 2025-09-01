{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    tag = "v${version}";
    hash = "sha256-U1vAupUthD5W0xvlOKdgm9MAVLqsVyZUaFdeLsDAbDM=";
    # .gitattributes is not correct or GitHub does not parse it correct and the archive is missing the test data
    forceFetchGit = true;
  };

  build-system = [ setuptools ];

  # only returns information how to really build
  dontConfigure = true;

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "python/tests" ];

  meta = with lib; {
    homepage = "https://github.com/google/brotli";
    description = "Generic-purpose lossless compression algorithm";
    license = licenses.mit;
    maintainers = [ ];
  };
}
