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
  version = "6.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v9G2wqmRp8yxsggrbenjuPGYtqK0oHqwgA4F3wWkU2E=";
  };

  propagatedBuildInputs = [ pyramid simplejson six venusian ];

  # tests not packaged with pypi release
  doCheck = false;
  pythonImportsCheck = [ "cornice" ];

  meta = with lib; {
    homepage = "https://github.com/mozilla-services/cornice";
    description = "Build Web Services with Pyramid";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
