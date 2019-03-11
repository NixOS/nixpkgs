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
  version = "5.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d908673a4010787625c8952e91a22adf737db031f2aa0793ad92f6558918a74a";
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

  meta = {
    description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
