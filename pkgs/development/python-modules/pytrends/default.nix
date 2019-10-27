{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, lxml
, pandas
}:

buildPythonPackage rec {
  pname = "pytrends";
  version = "4.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cf80573276b3a93c4fb2ff296c260fa86e7ab43709473ce34f3bad3841f06df";
  };

  doCheck = false;

  propagatedBuildInputs = [ requests lxml pandas ];

  meta = with stdenv.lib; {
    description = "Pseudo API for Google Trends";
    homepage = "https://github.com/GeneralMills/pytrends";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mmahut ];
  };

}
