{ stdenv
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
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d80ccb8cfa550139b50801591d4ca8a5575334adb493c402fce2312f55d07d66";
  };

  checkInputs = [ webtest zope_component ];

  propagatedBuildInputs = [ hupper PasteDeploy plaster plaster-pastedeploy repoze_lru translationstring venusian webob zope_deprecation zope_interface ];

  # Failing tests
  # https://github.com/Pylons/pyramid/issues/1899
  doCheck = !isPy35;

  meta = with stdenv.lib; {
    description = "The Pyramid Web Framework, a Pylons project";
    homepage = https://trypyramid.com/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
