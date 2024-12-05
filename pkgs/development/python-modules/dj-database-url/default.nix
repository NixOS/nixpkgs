{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "dj-database-url";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q0A9wA/k1xObw0e8+9qVTfpxBNL4W9rXisi0ge+R3DM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    typing-extensions
  ];

  # Tests access a DB via network
  doCheck = false;

  pythonImportsCheck = [ "dj_database_url" ];

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/jazzband/dj-database-url";
    changelog = "https://github.com/jazzband/dj-database-url/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
