{ lib
, buildPythonPackage
, fetchPypi
, nose
, glibcLocales
, isPy27
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
  version = "5.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cea3bbbd03c8e5842a1403347a8cc8134486b3ce081a2e5b1952a00ea66ed54";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [nose glibcLocales]  ++ lib.optionals isPy27 [mock];

  propagatedBuildInputs = [jinja2 tornado ipython_genutils traitlets jupyter_core
    jupyter_client nbformat nbconvert ipykernel terminado requests pexpect ];

  checkPhase = ''
    nosetests -v
  '';

  # Certain tests fail due to being in a chroot.
  # PermissionError
  doCheck = false;
  meta = {
    description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}