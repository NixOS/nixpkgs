{
  lib,
  buildPythonPackage,
  fetchPypi,
  repoze-lru,
  six,
  soupsieve,
  webob,
}:

buildPythonPackage (finalAttrs: {
  pname = "routes";
  version = "2.5.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Routes";
    inherit (finalAttrs) version;
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

  meta = {
    description = "Re-implementation of the Rails routes system for mapping URLs to application actions";
    homepage = "https://github.com/bbangert/routes";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
