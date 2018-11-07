{ stdenv
, buildPythonPackage
, fetchPypi
, traittypes
, six
, numpy
, ipywidgets
, nbval
, pytest
, matplotlib
}:

buildPythonPackage rec {
  pname = "ipydatawidgets";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b88219b58c3bb61d1af960860b62838fdcc6401d4e1b4449b4c93738858dd32d";
  };

  passthru = {
    jupyterlabExtensions = [ "jupyterlab-datawidgets" ];
  };

  checkInputs = [ nbval pytest ];
  propagatedBuildInputs = [ traittypes six numpy ipywidgets ];

  checkPhase = ''
    pytest ipydatawidgets
  '';

  meta = with stdenv.lib; {
    description = "A set of widgets to help facilitate reuse of large datasets across widgets";
    homepage = https://github.com/vidartf/ipydatawidgets;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
