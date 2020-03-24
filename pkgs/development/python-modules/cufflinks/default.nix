{ lib, buildPythonPackage, fetchPypi, fetchpatch
, chart-studio
, colorlover
, ipython
, ipywidgets
, pytest
, numpy
, pandas
, six
, statsmodels
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.17.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i56062k54dlg5iz3qyl1ykww62mpkp8jr4n450h0c60dm0b7ha8";
  };

  propagatedBuildInputs = [
    chart-studio
    colorlover
    ipython
    ipywidgets
    numpy
    pandas
    six
    statsmodels
  ];

  checkInputs = [ pytest ];

  # ignore tests which are incompatible with pandas>=1.0
  # https://github.com/santosjorge/cufflinks/issues/236
  checkPhase = ''
    pytest tests.py -k 'not bar_row'
  '';

  meta = with lib; {
    description = "Productivity Tools for Plotly + Pandas";
    homepage = "https://github.com/santosjorge/cufflinks";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
