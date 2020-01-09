{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, nose
, nose_warnings_filters
, glibcLocales
, isPy3k
, mock
, jinja2
, tornado
, ipython_genutils
, traitlets
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
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "6.0.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "399a4411e171170173344761e7fd4491a3625659881f76ce47c50231ed714d9b";
  };

  LC_ALL = "en_US.utf8";

  checkInputs = [ nose glibcLocales ]
    ++ (if isPy3k then [ nose_warnings_filters ] else [ mock ]);

  propagatedBuildInputs = [
    jinja2 tornado ipython_genutils traitlets jupyter_core send2trash
    jupyter_client nbformat nbconvert ipykernel terminado requests pexpect
    prometheus_client
  ];

  # disable warning_filters
  preCheck = lib.optionalString (!isPy3k) ''
    echo "" > setup.cfg
  '';

  postPatch = ''
    # Remove selenium tests
    rm -rf notebook/tests/selenium

  '';

  checkPhase = ''
    runHook preCheck
    mkdir tmp
    HOME=tmp nosetests -v ${if (stdenv.isDarwin) then ''
      --exclude test_delete \
      --exclude test_checkpoints_follow_file
    ''
    else ""}
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
    homepage = https://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
