{ buildPythonPackage, stdenv, fetchPypi
, numpy, pandas, plotly, six, colorlover
, ipython, ipywidgets, nose
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "014098a4568199957198c0a7fe3dbeb3b4010b6de8d692a41fe3b3ac107b660e";
  };

  propagatedBuildInputs = [
    numpy pandas plotly six colorlover
    ipython ipywidgets
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -xv tests.py
  '';

  meta = {
    homepage = https://github.com/santosjorge/cufflinks;
    description = "Productivity Tools for Plotly + Pandas";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ globin ];
  };
}
