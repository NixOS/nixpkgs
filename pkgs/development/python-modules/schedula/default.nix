{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # optional-dependencies
  dill,
  flask,
  graphviz,
  multiprocess,
  regex,
  requests,
  sphinx,
  sphinx-click,

  # tests
  pytestCheckHook,
  ddt,
  cryptography,
  schedula,
}:

buildPythonPackage rec {
  pname = "schedula";
  version = "1.5.62";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vinci1it2000";
    repo = "schedula";
    tag = "v${version}";
    hash = "sha256-erEUdiKV1MRwjVy3SKFneJVHp6gWEok7EWdv6v6HFGM=";
  };

  build-system = [ setuptools ];

  optional-dependencies = rec {
    # dev omitted, we have nativeCheckInputs for this
    # form omitted, as it pulls in a kitchensink of deps, some not even packaged in nixpkgs
    io = [ dill ];
    parallel = [ multiprocess ];
    plot = [
      requests
      graphviz
      regex
      flask
    ];
    sphinx = [
      sphinx
      sphinx-click
    ] ++ plot;
    web = [
      requests
      regex
      flask
    ];
  };

  nativeCheckInputs =
    [
      cryptography # doctests
      ddt
      sphinx
      pytestCheckHook
    ]
    ++ schedula.optional-dependencies.io
    ++ schedula.optional-dependencies.parallel
    ++ schedula.optional-dependencies.plot;

  disabledTests = [
    # FAILED tests/test_setup.py::TestSetup::test_long_description - ModuleNotFoundError: No module named 'sphinxcontrib.writers'
    "test_long_description"
  ];

  disabledTestPaths = [
    # ERROR tests/utils/test_form.py::TestDispatcherForm::test_form1 - ModuleNotFoundError: No module named 'chromedriver_autoinstaller'
    # ERROR tests/utils/test_form.py::TestDispatcherForm::test_form_stripe - ModuleNotFoundError: No module named 'chromedriver_autoinstaller'
    "tests/utils/test_form.py"
  ];

  pythonImportsCheck = [ "schedula" ];

  meta = {
    description = "Smart function scheduler for dynamic flow-based programming";
    homepage = "https://github.com/vinci1it2000/schedula";
    changelog = "https://github.com/vinci1it2000/schedula/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.eupl11;
    maintainers = with lib.maintainers; [ flokli ];
    # at least some tests fail on Darwin
    platforms = lib.platforms.linux;
  };
}
