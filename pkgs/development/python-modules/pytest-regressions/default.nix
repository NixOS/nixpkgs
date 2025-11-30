{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  matplotlib,
  numpy,
  pandas,
  pillow,
  pytest,
  pytest-datadir,
  pytestCheckHook,
  pyyaml,
  setuptools-scm,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pytest-regressions";
  version = "2.8.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ESSS";
    repo = "pytest-regressions";
    tag = "v${version}";
    hash = "sha256-8FbPWKYHy/0ITrCx9044iYOR7B9g8tgEdV+QfUg4esk=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [
    pytest-datadir
    pyyaml
  ];

  optional-dependencies = {
    dataframe = [
      pandas
      numpy
    ];
    image = [
      numpy
      pillow
    ];
    num = [
      numpy
      pandas
    ];
  };

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isBigEndian) [
    # https://github.com/ESSS/pytest-regressions/issues/156
    # i686-linux not listed in the report, but seems to have this issue as well
    "test_different_data_types"
    "test_common_case" # not listed in the issue, but fails after the above is skipped
  ];

  pythonImportsCheck = [
    "pytest_regressions"
    "pytest_regressions.plugin"
  ];

  disabledTestPaths = lib.optionals (stdenv.system == "i686-linux") [
    "tests/test_ndarrays_regression.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/ESSS/pytest-regressions/blob/${src.tag}/CHANGELOG.rst";
    description = "Pytest fixtures to write regression tests";
    longDescription = ''
      pytest-regressions makes it simple to test general data, images,
      files, and numeric tables by saving expected data in a data
      directory (courtesy of pytest-datadir) that can be used to verify
      that future runs produce the same data.
    '';
    homepage = "https://github.com/ESSS/pytest-regressions";
    license = licenses.mit;
    maintainers = [ ];
  };
}
