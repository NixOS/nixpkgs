{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8gQs7+EIblOcnaOfrVrX9hFzv3lmXmm/fk3lX6iLE18=";
  };

  propagatedBuildInputs = [ django ];

  # Tests access a DB via network
  doCheck = false;

  pythonImportsCheck = [ "dj_database_url" ];

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/jazzband/dj-database-url";
    changelog = "https://github.com/jazzband/dj-database-url/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
