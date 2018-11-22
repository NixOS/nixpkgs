{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "599bc5b4b9602e28294cf795733c889c26dd934aa7e0ee9cff9b905d4fbad188";
  };

  buildInputs = [ glibcLocales ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = with stdenv.lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = http://code.google.com/p/prettytable/;
    license = licenses.bsd0;
  };

}
