{ stdenv, buildPythonPackage, fetchPypi, idna }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "19.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4288e34705da077fada1111a24a0aa08bb1e76699c9ce49876af722441845654";
  };

  propagatedBuildInputs = [ idna ];

  meta = with stdenv.lib; {
    description = "A featureful, correct URL for Python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
