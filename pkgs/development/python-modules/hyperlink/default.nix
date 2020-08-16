{ stdenv, buildPythonPackage, fetchPypi, idna }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "20.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47fcc7cd339c6cb2444463ec3277bdcfe142c8b1daf2160bdd52248deec815af";
  };

  propagatedBuildInputs = [ idna ];

  meta = with stdenv.lib; {
    description = "A featureful, correct URL for Python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
