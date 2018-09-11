{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d5460dc9db74a32bcc8f9f67de68b2c4f4d2f01fa3bd518764c69156d9cacd9";
  };

  buildInputs = [ pkgs.glibcLocales ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = with stdenv.lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = http://code.google.com/p/prettytable/;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
