{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  astropy,
  requests,

  # optional dependencies
  pillow,
  defusedxml,

  # testing
  pytestCheckHook,
  pytest-astropy,
  pytest-timeout,
  pytest-doctestplus,
  requests-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvo";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = finalAttrs.pname;
    # A few commits above 1.9.1 to include https://github.com/astropy/pyvo/pull/757,
    # which fixes tests
    rev = "6c5311c06cd04cf0c56f648ccdae50338cc351a2";
    hash = "sha256-kqYA/qgqTZe4GwOwtzIKy/X3mrVukn7mq3CiqJIWI+A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy
    requests
  ];

  optional-dependencies = {
    all = [
      pillow
      defusedxml
    ];
    test = [
      pytest-astropy
      pytest-timeout
      pytest-doctestplus
      requests-mock
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ (with finalAttrs.passthru.optional-dependencies; all ++ test);

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  disabledTestPaths = [
    # touches network
    "pyvo/dal/tests/test_datalink.py"
  ];

  pythonImportsCheck = [ "pyvo" ];

  meta = with lib; {
    description = "Astropy affiliated package for accessing Virtual Observatory data and services";
    homepage = "https://github.com/astropy/pyvo";
    changelog = "https://github.com/astropy/pyvo/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
})
