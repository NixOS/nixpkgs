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
  version = "1.12.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c63f76d1ce2261eb0cd147a24be25daff399e7df2c3d6ade3e813d2e9cb7d42f";
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
