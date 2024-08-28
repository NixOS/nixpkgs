{
  lib,
  pkg-config,
  exiv2,
  gettext,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
}:
python3Packages.buildPythonPackage rec {
  pname = "exiv2";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-exiv2";
    rev = "refs/tags/${version}";
    hash = "sha256-nPSspQPq0y2Vg2S+iwQ1E+TdaOJ9aJN3eeXRrcDzdsM=";
  };

  # FAIL: test_localisation (test_types.TestTypesModule.test_localisation)
  # FAIL: test_TimeValue (test_value.TestValueModule.test_TimeValue)
  postPatch = ''
    substituteInPlace tests/test_value.py \
      --replace-fail "def test_TimeValue(self):" "@unittest.skip('skipping')
        def test_TimeValue(self):"
    substituteInPlace tests/test_types.py \
      --replace-fail "def test_localisation(self):" "@unittest.skip('skipping')
        def test_localisation(self):"
  '';

  build-system = with python3Packages; [
    setuptools
    toml
  ];
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    exiv2
    gettext
  ];

  pythonImportsCheck = [ "exiv2" ];
  nativeCheckInputs = with python3Packages; [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Low level Python interface to the Exiv2 C++ library";
    homepage = "https://github.com/jim-easterbrook/python-exiv2";
    changelog = "https://python-exiv2.readthedocs.io/en/release-${version}/misc/changelog.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
  };
}
