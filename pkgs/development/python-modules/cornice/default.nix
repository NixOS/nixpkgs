{ lib
, buildPythonPackage
, fetchPypi
, pyramid
, simplejson
, six
, venusian
}:

buildPythonPackage rec {
  pname = "cornice";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "532485ed53cae81ef476aaf4cc7c2e0208749ad1959119c46efefdeea5546eba";
  };

  propagatedBuildInputs = [ pyramid simplejson six venusian ];

  # tests not packaged with pypi release
  doCheck = false;
  pythonImportsCheck = [ "cornice" ];

  meta = with lib; {
    homepage = "https://github.com/mozilla-services/cornice";
    description = "Build Web Services with Pyramid";
    license = licenses.mpl20;
    maintainers = [ maintainers.costrouc ];
  };
}
