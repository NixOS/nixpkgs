{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs,
  mkdocs-material,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocs-redoc-tag";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Blueswen";
    repo = "mkdocs-redoc-tag";
    tag = "v${version}";
    hash = "sha256-pgJMcK8LZOj0niyRcbHi8Szsro2iNTj6hz6r24jrtVw=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    mkdocs
    beautifulsoup4
  ];

  nativeCheckInputs = [
    mkdocs-material
    pytestCheckHook
  ];

  pytestFlags = [ "-s" ];

  meta = with lib; {
    description = "MkDocs plugin supports for add Redoc UI in page";
    homepage = "https://github.com/blueswen/mkdocs-redoc-tag";
    changelog = "https://github.com/blueswen/mkdocs-redoc-tag/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ benhiemer ];
  };
}
