{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, argon2-cffi
, nose
, nose_warnings_filters
, glibcLocales
, isPy3k
, mock
, jinja2
, tornado
, ipython_genutils
, traitlets
, jupyter-core
, jupyter-client
, nbformat
, nbconvert
, ipykernel
, terminado
, requests
, send2trash
, pexpect
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "6.5.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wYl+UxfiJfx4tFVJpqtLZo5MmW/QOgTpOP5eevK//9A=";
  };

  LC_ALL = "en_US.utf8";

  checkInputs = [ nose pytestCheckHook glibcLocales ]
    ++ (if isPy3k then [ nose_warnings_filters ] else [ mock ]);

  propagatedBuildInputs = [
    jinja2 tornado ipython_genutils traitlets jupyter-core send2trash
    jupyter-client nbformat nbconvert ipykernel terminado requests pexpect
    prometheus-client argon2-cffi
  ];

  # disable warning_filters
  preCheck = lib.optionalString (!isPy3k) ''
    echo "" > setup.cfg
  '';

  postPatch = ''
    # Remove selenium tests
    rm -rf notebook/tests/selenium
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # a "system_config" is generated, and fails many tests
    "config"
    "load_ordered"
    # requires jupyter, but will cause circular imports
    "test_run"
    "TestInstallServerExtension"
    "launch_socket"
    "sock_server"
    "test_list_formats" # tries to find python MIME type
    "KernelCullingTest" # has a race condition failing on slower hardware
  ] ++ lib.optionals stdenv.isDarwin [
    "test_delete"
    "test_checkpoints_follow_file"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # requires local networking
    "notebook/auth/tests/test_login.py"
    "notebook/bundler/tests/test_bundler_api.py"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
