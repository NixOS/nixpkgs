{ lib
, buildPythonPackage
, fetchPypi
, webtest
, zope_component
, hupper
, pastedeploy
, plaster
, plaster-pastedeploy
, repoze_lru
, translationstring
, venusian
, webob
, zope_deprecation
, zope_interface
}:

buildPythonPackage rec {
  pname = "pyramid";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+r/XRQOeJq1bCRX8OW6HJcD4o9F7lB+WEezR7XbP59o=";
  };

  nativeCheckInputs = [ webtest zope_component ];

  propagatedBuildInputs = [ hupper pastedeploy plaster plaster-pastedeploy repoze_lru translationstring venusian webob zope_deprecation zope_interface ];

  pythonImportsCheck = [ "pyramid" ];

  meta = with lib; {
    description = "The Pyramid Web Framework, a Pylons project";
    homepage = "https://trypyramid.com/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
