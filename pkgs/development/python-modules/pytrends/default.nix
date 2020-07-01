{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, lxml
, pandas
}:

buildPythonPackage rec {
  pname = "pytrends";
  version = "4.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ccb06c57c31fa157b978a0d810de7718ee46583d28cf818250d45f36abd2faa";
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
