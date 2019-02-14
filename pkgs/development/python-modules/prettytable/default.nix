{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b5df88a819145657ae64cab4bc32dd19dce16ed1263584b08f4c5199443b80d";
  };

  buildInputs = [ glibcLocales ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = with stdenv.lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = http://code.google.com/p/prettytable/;
    license = licenses.bsd3;
  };

}
