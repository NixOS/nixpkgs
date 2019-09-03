{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, lxml
, pandas
}:

buildPythonPackage rec {
  pname = "pytrends";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03gnn2mgjvpc7pbcijy7xilrhgjg7x2pp6ci96pdyqnhkqv02d3n";
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
