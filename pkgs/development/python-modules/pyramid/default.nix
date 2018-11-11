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
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37c3e1c9eae72817e0365e2a38143543aee8b75240701fa5cb3a1be86c01a1c0";
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
