{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  primp,
  lxml,
  httpx,
  h2,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ddgs";
  version = "9.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${version}";
    hash = "sha256-NaOwklHea3TUDa2M23X549IiX5zP87N9qWKkr5PObLY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    primp
    lxml
    httpx
    h2
  ]
  ++ httpx.optional-dependencies.http2
  ++ httpx.optional-dependencies.socks
  ++ httpx.optional-dependencies.brotli;

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  pythonImportsCheck = [ "ddgs" ];

  meta = {
    description = "D.D.G.S. | Dux Distributed Global Search. A metasearch library that aggregates results from diverse web search services";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/ddgs";
    changelog = "https://github.com/deedy5/ddgs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
