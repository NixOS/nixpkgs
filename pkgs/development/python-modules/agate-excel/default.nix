{ lib, fetchPypi, buildPythonPackage
, agate, openpyxl, xlrd, nose
}:

buildPythonPackage rec {
  pname = "agate-excel";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f255ef2c87c436b7132049e1dd86c8e08bf82d8c773aea86f3069b461a17d52";
  };

  propagatedBuildInputs = [ agate openpyxl xlrd ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Adds read support for excel files to agate";
    homepage    = https://github.com/wireservice/agate-excel;
    license     = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
