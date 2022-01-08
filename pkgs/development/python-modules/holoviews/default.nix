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
  version = "1.14.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d8d171227e9c9eaadd4b037b3ddaa01055a33bacbdbeb57a5efbd273986665f";
  };

  propagatedBuildInputs = [
    colorcet
    numpy
    pandas
    panel
    param
    pyviz-comms
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
