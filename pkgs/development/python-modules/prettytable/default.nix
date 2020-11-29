{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e37acd91976fe6119172771520e58d1742c8479703489321dc1d9c85e7259922";
  };

  buildInputs = [ glibcLocales ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = with stdenv.lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = "http://code.google.com/p/prettytable/";
    license = licenses.bsd3;
  };

}
