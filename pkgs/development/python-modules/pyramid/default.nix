{ lib
, buildPythonPackage
, fetchPypi
, webtest
, zope_component
, hupper
, PasteDeploy
, plaster
, plaster-pastedeploy
, repoze_lru
, translationstring
, venusian
, webob
, zope_deprecation
, zope_interface
, isPy35
}:

buildPythonPackage rec {
  pname = "pyramid";
  version = "1.10.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7cd66595bef92f81764b976ddde2b2fa8e4f5f325e02f65f6ec7f3708b29cf6";
  };

  checkInputs = [ webtest zope_component ];

  propagatedBuildInputs = [ hupper PasteDeploy plaster plaster-pastedeploy repoze_lru translationstring venusian webob zope_deprecation zope_interface ];

  # Failing tests
  # https://github.com/Pylons/pyramid/issues/1899
  doCheck = !isPy35;

  pythonImportsCheck = [ "pyramid" ];

  meta = with lib; {
    description = "The Pyramid Web Framework, a Pylons project";
    homepage = "https://trypyramid.com/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
