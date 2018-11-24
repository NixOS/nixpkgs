{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ndckiniasacfqcdafzs04plskrcigk7vxprr2y34jmpkpf60m1d";
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
