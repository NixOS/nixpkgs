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
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50f86a5e9fb73d664d20e8dd0bdc3ce419145eb17813591a5a40e8a9d567b9c5";
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
