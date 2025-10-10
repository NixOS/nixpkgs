{
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
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "pytest_regressions"
    "pytest_regressions.plugin"
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
