{ buildPythonPackage
, fetchPypi
, lib
, param
, numpy
, pyviz-comms
, ipython
, notebook
, pandas
, matplotlib
, bokeh
, scipy
, panel
}:

buildPythonPackage rec {
  pname = "holoviews";
  version = "1.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df64c0f163fe8b43d28cf5bcdeb8abc45d882aedca525b870f17987edd0c80a2";
  };

  propagatedBuildInputs = [
    param
    numpy
    pyviz-comms
    ipython
    notebook
    pandas
    matplotlib
    bokeh
    scipy
    panel
  ];

  # tests not fully included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "Python data analysis and visualization seamless and simple";
    homepage = http://www.holoviews.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
