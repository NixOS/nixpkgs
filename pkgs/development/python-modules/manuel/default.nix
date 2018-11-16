{ stdenv
, buildPythonPackage
, fetchPypi
, six
, zope_testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1diyj6a8bvz2cdf9m0g2bbx9z2yjjnn3ylbg1zinpcjj6vldfx59";
  };

  propagatedBuildInputs = [ six zope_testing ];

  meta = with stdenv.lib; {
    description = "A documentation builder";
    homepage = https://pypi.python.org/pypi/manuel;
    license = licenses.zpl20;
  };

}
