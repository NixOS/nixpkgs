{ stdenv, fetchPypi, buildPythonPackage
, psutil
, pytest }:

buildPythonPackage rec {
  pname = "PyPrind";
  version = "2.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xg6m5hr33h9bdlrr42kc58jm2m87a9zsagy7n2m4n407d2snv64";
  };

  buildInputs = [ psutil ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Python Progress Bar and Percent Indicator Utility";
    homepage = "https://github.com/rasbt/pyprind";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
