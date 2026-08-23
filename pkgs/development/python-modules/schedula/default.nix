{
  lib,
  buildPythonPackage,
  pythonAtLeast,
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
  version = "1.5.78";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vinci1it2000";
    repo = "schedula";
    tag = "v${version}";
    hash = "sha256-fhcG2N524KlwaG+inOyQJaXKoMhmR6Yddff8CDi8lhk=";
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
    ]
    ++ plot;
    web = [
      requests
      regex
      flask
    ];
  };

  nativeCheckInputs = [
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
    # requires schedula[form] extras
    "tests/utils/test_form_items.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # itertools iterators no longer picklable in 3.14 (cpython#101588)
    "tests/test_dispatcher.py::TestAsyncParallel"
    "tests/test_dispatcher.py::TestCopyDispatcher::test_copy"
    "tests/utils/test_blue.py::TestBlueDispatcher::test_blue_io"
    "tests/utils/test_io.py::TestReadWrite::test_load_dispatcher"
    "tests/utils/test_io.py::TestReadWrite::test_save_dispatcher"
    # exception repr format changed in 3.14
    "tests/test_dispatcher.py::TestDispatch::test_raises"
    # doctest output drift on 3.14
    "tests/test_dispatcher.py::TestDoctest::runTest"
    "tests/utils/test_io.py::TestDoctest::runTest"
  ];

  pythonImportsCheck = [ "schedula" ];

  meta = {
    description = "Smart function scheduler for dynamic flow-based programming";
    homepage = "https://github.com/vinci1it2000/schedula";
    changelog = "https://github.com/vinci1it2000/schedula/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.eupl11;
    maintainers = with lib.maintainers; [ flokli ];
    # at least some tests fail on Darwin
    platforms = lib.platforms.linux;
  };
}
