{ stdenv
, buildPythonPackage
, fetchPypi
, pyramid
, simplejson
, six
, venusian
}:

buildPythonPackage rec {
  pname = "cornice";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e95dceaee9ce16a09564c1226977a0fe62f1399701581b59c4188f5c91a86687";
  };

  propagatedBuildInputs = [ pyramid simplejson six venusian ];

  # tests not packaged with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mozilla-services/cornice;
    description = "Build Web Services with Pyramid";
    license = licenses.mpl20;
    maintainers = [ maintainers.costrouc ];
  };

}
