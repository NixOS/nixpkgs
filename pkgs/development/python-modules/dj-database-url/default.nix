{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "dj-database-url";
    tag = "v${version}";
    hash = "sha256-wiPTszgix4QjF82f5mmNvDKGspYl15jScK2TAsP5zP8=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

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
