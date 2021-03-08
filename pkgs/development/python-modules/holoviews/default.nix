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
  version = "1.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64f85cf2c99b083b96f26cd26452aec4b41ced6d9e57f56ae8d72b88defc61c9";
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
