{ lib
, buildPythonPackage
, fetchPypi
, repoze_lru
, six
, soupsieve
, webob
, coverage
, webtest
}:

buildPythonPackage rec {
  pname = "Routes";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6346459a15f0cbab01a45a90c3d25caf980d4733d628b4cc1952b865125d053";
  };

  propagatedBuildInputs = [ repoze_lru six soupsieve webob ];
  # incompatible with latest soupsieve
  doCheck = false;
  checkInputs = [ coverage soupsieve webtest ];

  pythonImportsCheck = [ "routes" ];

  meta = with lib; {
    description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
    homepage = "http://routes.groovie.org/";
    license = licenses.mit;
  };

}
