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
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd431fad9bdd25aa9ff8265da096ef770475e21bf1d327982611a7de5cd904ca";
  };

  LC_ALL = "en_US.utf8";

  buildInputs = [ nose glibcLocales ]
    ++ (if isPy3k then [ nose_warnings_filters ] else [ mock ]);

  propagatedBuildInputs = [
    jinja2 tornado ipython_genutils traitlets jupyter_core send2trash
    jupyter_client nbformat nbconvert ipykernel terminado requests pexpect
  ];

  # disable warning_filters
  preCheck = lib.optionalString (!isPy3k) ''
    echo "" > setup.cfg
    cat setup.cfg
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
