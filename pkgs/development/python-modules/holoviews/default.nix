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
  version = "1.14.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "268e07c09012d24233d8957f0207b9aec33000b639e661ca50e68458d735e6be";
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
