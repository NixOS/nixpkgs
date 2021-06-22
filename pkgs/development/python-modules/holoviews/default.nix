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
  version = "1.14.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08e8be82c2e514e1700a75f02307f414179dc0ecfa2202702dd304a381909eaa";
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

  meta = with lib; {
    description = "Python data analysis and visualization seamless and simple";
    homepage = "http://www.holoviews.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
