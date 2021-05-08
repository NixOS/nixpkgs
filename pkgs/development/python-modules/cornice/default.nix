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
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c81cd9429759c0de475f580bbff92d5646cfc5f43e8aa24492037e2e90677ee6";
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
