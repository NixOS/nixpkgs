{ lib
, buildPythonPackage
, fetchPypi
, repoze_lru
, six
, soupsieve
, webob
}:

buildPythonPackage rec {
  pname = "routes";
  version = "2.5.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Routes";
    inherit version;
    sha256 = "b6346459a15f0cbab01a45a90c3d25caf980d4733d628b4cc1952b865125d053";
  };

  propagatedBuildInputs = [ repoze_lru six soupsieve webob ];

  # incompatible with latest soupsieve
  doCheck = false;

  pythonImportsCheck = [ "routes" ];

  meta = with lib; {
    description = "Re-implementation of the Rails routes system for mapping URLs to application actions";
    homepage = "https://github.com/bbangert/routes";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
