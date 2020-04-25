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
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00i8732qib86xqa3652vkr178ib3682cls4jcv5g52y0rlkd8bfg";
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
    homepage = "http://www.holoviews.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
