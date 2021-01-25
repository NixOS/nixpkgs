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
  version = "1.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe1bd1140e6b79fe07f0053981d49be2dc66656cc8b481dd7ffcaa872fc25467";
  };

  checkInputs = [ webtest zope_component ];

  propagatedBuildInputs = [ hupper PasteDeploy plaster plaster-pastedeploy repoze_lru translationstring venusian webob zope_deprecation zope_interface ];

  # Failing tests
  # https://github.com/Pylons/pyramid/issues/1899
  doCheck = !isPy35;

  meta = with lib; {
    description = "The Pyramid Web Framework, a Pylons project";
    homepage = "https://trypyramid.com/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
