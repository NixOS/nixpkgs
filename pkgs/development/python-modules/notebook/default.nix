{ lib
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
, pexpect
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "5.2.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bb54fb61b9c5426bc116f840541b973431198e00ea2896122d05fc122dbbd67";
  };

  LC_ALL = "en_US.utf8";

  buildInputs = [ nose glibcLocales ]
    ++ (if isPy3k then [ nose_warnings_filters ] else [ mock ]);

  propagatedBuildInputs = [
    jinja2 tornado ipython_genutils traitlets jupyter_core
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
    HOME=tmp nosetests -v
  '';

  meta = {
    description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
