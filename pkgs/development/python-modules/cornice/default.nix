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
  version = "3.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1355f998ac6af53bda985e13ed0695cd206b0a3f14657b83979b31bbc72f1acb";
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
