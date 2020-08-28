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
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fcf3be295514e7e20fdd602fea8d204127bb02da2ff6bdbc8b6fba859ac9fd0";
  };

  propagatedBuildInputs = [ pyramid simplejson six venusian ];

  # tests not packaged with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla-services/cornice";
    description = "Build Web Services with Pyramid";
    license = licenses.mpl20;
    maintainers = [ maintainers.costrouc ];
  };

}
