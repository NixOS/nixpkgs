{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "dj-database-url";
    tag = "v${version}";
    hash = "sha256-olE1tufGXOl8rOKN+Pa0eXhYEzeQxTqj50X6AVwYkM8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    typing-extensions
  ];

  # Tests access a DB via network
  doCheck = false;

  pythonImportsCheck = [ "dj_database_url" ];

  meta = {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/jazzband/dj-database-url";
    changelog = "https://github.com/jazzband/dj-database-url/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
