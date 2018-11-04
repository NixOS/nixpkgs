{ stdenv
, buildPythonPackage
, fetchPypi
, docutils
, virtualenv
, webtest
, zope_component
, hupper
, PasteDeploy
, plaster
, plaster-pastedeploy
, repoze_lru
, repoze_sphinx_autointerface
, translationstring
, venusian
, webob
, zope_deprecation
, zope_interface
, isPy35
}:

buildPythonPackage rec {
  pname = "pyramid";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f91bcb8ee8ad3168eaf836d701b7b8c59481cec9ca085ab0251d1b953ffc46a";
  };

  checkInputs = [ docutils virtualenv webtest zope_component ];

  propagatedBuildInputs = [ hupper PasteDeploy plaster plaster-pastedeploy repoze_lru repoze_sphinx_autointerface translationstring venusian webob zope_deprecation zope_interface ];

  # Failing tests
  # https://github.com/Pylons/pyramid/issues/1899
  doCheck = !isPy35;

  meta = with stdenv.lib; {
    description = "The Pyramid Web Framework, a Pylons project";
    homepage = https://trypyramid.com/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
