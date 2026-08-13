{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
}:
buildPythonPackage rec {
  pname = "mkdocs-simple-blog";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = "mkdocs-simple-blog";
    tag = "v${version}";
    hash = "sha256-lp0+mJYyP7Qz/gJCI7+tKh9fZArWs2u1ZusnVUax7A4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mkdocs
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "mkdocs_simple_blog" ];

  meta = {
    description = "Simple blog generator plugin for MkDocs";
    homepage = "https://fernandocelmer.github.io/mkdocs-simple-blog/";
    changelog = "https://github.com/FernandoCelmer/mkdocs-simple-blog/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
