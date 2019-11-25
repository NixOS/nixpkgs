{ lib, buildPythonPackage, fetchPypi, fetchpatch
, chart-studio
, colorlover
, ipython
, ipywidgets
, nose
, numpy
, pandas
, six
, statsmodels
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "163lag5g4micpqm3m4qy9b5r06a7pw45nq80x4skxc7dcrly2ygd";
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

  patches = [
    # Plotly 4 compatibility. Remove with next release, assuming it gets merged.
    (fetchpatch {
      url = "https://github.com/santosjorge/cufflinks/pull/202/commits/e291dce14181858cb457404adfdaf2624b6d0594.patch";
      sha256 = "1l0dahwqn3cxg49v3i3amwi80dmx2bi5zrazmgzpwsfargmk2kd1";
    })
  ];

  # in plotly4+, the plotly.plotly module was moved to chart-studio.plotly
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "plotly>=3.0.0,<4.0.0a0" "chart-studio"
  '';

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -xv tests.py
  '';

  meta = with lib; {
    description = "Productivity Tools for Plotly + Pandas";
    homepage = "https://github.com/santosjorge/cufflinks";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
