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
  version = "3.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c88f246aa6a84a0cdbaa8231a062c60e18ad9c0a65dc178f536ce5eb3a831418";
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
