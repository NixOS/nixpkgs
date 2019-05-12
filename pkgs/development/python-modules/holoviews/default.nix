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
  version = "1.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i4lfnajz685hlp9m0bjn7s279bv6mm5118b1qmldzqdnvw4s032";
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
