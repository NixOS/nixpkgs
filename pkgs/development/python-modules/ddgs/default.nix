{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
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

  patches = [
    # We're removing the HTTP client primp below for security reasons,
    # but can use the already included httpx instead.
    # Note that while httpx is only used for HTTP/2 by upstream,
    # it can handle HTTP/1.1 just fine as well.
    ./replace-primp.patch
  ];

  pythonRemoveDeps = [
    # primp requires a very outdated, potentially insecure version of boringssl
    "primp"
  ];

  build-system = [ setuptools ];

  dependencies = [
    click
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
