{ lib
, buildPythonPackage
, fetchPypi
, pytest
, glibcLocales
, ipython_genutils
, traitlets
, testpath
, jsonschema
, jupyter_core
}:

buildPythonPackage rec {
  pname = "nbformat";
  version = "4.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5febcce872672f1c97569e89323992bdcb8573fdad703f835e6521253191478b";
  };
  LC_ALL="en_US.UTF-8";

  checkInputs = [ pytest glibcLocales ];
  propagatedBuildInputs = [ ipython_genutils traitlets testpath jsonschema jupyter_core ];

  # Failing tests and permission issues
  doCheck = false;

  meta = {
    description = "The Jupyter Notebook format";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
