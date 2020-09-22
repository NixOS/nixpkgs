{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, argon2_cffi
, nose
, nose_warnings_filters
, glibcLocales
, isPy3k
, mock
, jinja2
, tornado
, ipython_genutils
, traitlets
, jupyter
, jupyter_core
, jupyter_client
, nbformat
, nbconvert
, ipykernel
, terminado
, requests
, send2trash
, pexpect
, prometheus_client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "6.1.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cnyi4zd3byh7zixdj2q71axm31xgjiyfklh1c63c87acgwh2zb8";
  };

  LC_ALL = "en_US.utf8";

  checkInputs = [ nose pytestCheckHook glibcLocales ]
    ++ (if isPy3k then [ nose_warnings_filters ] else [ mock ]);

  propagatedBuildInputs = [
    jinja2 tornado ipython_genutils traitlets jupyter_core send2trash
    jupyter_client nbformat nbconvert ipykernel terminado requests pexpect
    prometheus_client argon2_cffi
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
  ]
  ++ lib.optional stdenv.isDarwin [
    "test_delete"
    "test_checkpoints_follow_file" 
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
