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
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dab97fe52d7075ecc87b8cadf549ca2c2c628512741193fb81a0c0433b46715";
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
