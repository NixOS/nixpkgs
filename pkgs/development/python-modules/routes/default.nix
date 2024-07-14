{
  lib,
  buildPythonPackage,
  fetchPypi,
  repoze-lru,
  six,
  soupsieve,
  webob,
}:

buildPythonPackage rec {
  pname = "routes";
  version = "2.5.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Routes";
    inherit version;
    hash = "sha256-tjRkWaFfDLqwGkWpDD0lyvmA1HM9YotMwZUrhlEl0FM=";
  };

  propagatedBuildInputs = [
    repoze-lru
    six
    soupsieve
    webob
  ];

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
