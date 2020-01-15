{ stdenv, buildPythonPackage, fetchPypi, idna }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "18.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f01b4ff744f14bc5d0a22a6b9f1525ab7d6312cb0ff967f59414bbac52f0a306";
  };

  propagatedBuildInputs = [ idna ];

  meta = with stdenv.lib; {
    description = "A featureful, correct URL for Python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
