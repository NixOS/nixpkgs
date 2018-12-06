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
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dhbzc4q0vsnv3aihy728aczg56xs6h9s1rmvr096q4lb6yln3w4";
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
