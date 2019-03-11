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
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0902wzzz73ikkdy0jfhg1lx97y1gk7v1nr3d3jqqdfzaa7bmhqwj";
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
