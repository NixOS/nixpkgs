{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchurl,
  lz4,
  pytestCheckHook,
  setuptools,
  zstandard,
}:

let
  version = "1.4.0";
  fixturesRef = "refs/tags/releases/python/mcap/v${version}";
  # test fixtures are absent from sdist, but present in the monorepo under git-lfs
  demo-mcap = fetchurl {
    url = "https://media.githubusercontent.com/media/foxglove/mcap/${fixturesRef}/testdata/mcap/demo.mcap";
    hash = "sha256-uQoK9EK/xqrzHXrgo2HwTSpO7MpxaPmRc5G3RpevXIw=";
  };
  one-message-mcap = fetchurl {
    url = "https://media.githubusercontent.com/media/foxglove/mcap/${fixturesRef}/tests/conformance/data/OneMessage/OneMessage.mcap";
    hash = "sha256-c7iBIzDJonJV270OSg66UH/d0X49YFyjUVYMHcyoW8s=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "mcap";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    pname = "mcap";
    inherit version;
    hash = "sha256-BSji+Gphv+xzd54GKObPJ6+D0B2J4gsn1eyfC1VqY6w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lz4
    zstandard
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # these tests read the git-lfs fixtures; passthru.tests.full runs them
  disabledTestPaths = [
    "tests/test_read_crc_validation.py"
    "tests/test_reader.py"
  ];

  pythonImportsCheck = [ "mcap" ];

  passthru.tests = {
    # the whole suite, with the fixtures placed where the tests expect them
    # relative to their monorepo home at python/mcap/tests
    full = finalAttrs.finalPackage.overrideAttrs (old: {
      disabledTestPaths = [ ];
      preCheck = ''
        mkdir -p python/mcap
        mv tests python/mcap/tests
        mkdir -p testdata/mcap tests/conformance/data/OneMessage
        cp ${demo-mcap} testdata/mcap/demo.mcap
        cp ${one-message-mcap} tests/conformance/data/OneMessage/OneMessage.mcap
      '';
    });
  };

  meta = {
    description = "Python library for reading and writing MCAP log files";
    homepage = "https://github.com/foxglove/mcap";
    changelog = "https://github.com/foxglove/mcap/releases/tag/releases%2Fpython%2Fmcap%2Fv${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfr ];
  };
})
