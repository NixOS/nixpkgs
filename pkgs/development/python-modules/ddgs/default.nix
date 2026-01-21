{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  lxml,
  httpx,
  h2,
  fake-useragent,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ddgs";
  version = "9.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${version}";
    hash = "sha256-NNXGvDGynu6QtVqxVr74b/qehQ7qhq1NiVxyuKw2C4w=";
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
    fake-useragent
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
