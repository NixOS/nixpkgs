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
, colorcet
}:

buildPythonPackage rec {
  pname = "holoviews";
  version = "1.14.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a25c4fe3195fdc4639461abbfa5a8bebce8ab737674b6673da2236a901cfefd";
  };

  propagatedBuildInputs = [
    colorcet
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

  pythonImportsCheck = [ "holoviews" ];

  meta = with lib; {
    description = "Python data analysis and visualization seamless and simple";
    homepage = "http://www.holoviews.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
