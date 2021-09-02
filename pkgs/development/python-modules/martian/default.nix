{ lib, buildPythonPackage, fetchPypi, callPackage
, setuptools, zc_buildout, zope_interface, six
# tox, zope_testing, zope_testrunner, coverage#, zc_recipe_testrunner
}:

buildPythonPackage rec {
  pname = "martian";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4b48f3004f9b30789ef4fba7bb5748ff0522a80d9906b78e61fa7d1ae060883";
  };

  propagatedBuildInputs = [
    setuptools
    zc_buildout
    zope_interface
    six
  ];

  # checkInputs = [
  #   #zc_recipe_testrunner # Missing dependency blocked on 'zc.recipe.egg'
  #   zope_testing
  #   tox
  #   coverage
  #   zope_testrunner
  # ];
  # checkPhase = ''
  #   runHook preCheck
  #   zope-testrunner --test-path=src []
  #   runHook postCheck
  # '';
  doCheck = false;

  pythonImportsCheck = [ "martian" ];

  meta = with lib; {
    description = "A library to embed configuration information in Python code";
    downloadPage = "https://pypi.org/project/martian/";
    homepage = "https://github.com/zopefoundation/martian";
    license = licenses.zpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
