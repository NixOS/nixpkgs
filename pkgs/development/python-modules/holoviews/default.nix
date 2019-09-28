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
  version = "1.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15cay2fnhwqr42s4hiq37b8q87sir5k59p14g96mvg5p0gjnhg3w";
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
