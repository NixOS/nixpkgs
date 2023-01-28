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
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45431b387587ed0fac6213b54d6e9f0936f0cc85238a8f5af7852fc9484c5c77";
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
