{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  click,
  essentials-openapi,
  flask,
  hatchling,
  httpx,
  jinja2,
  mkdocs,
  pytestCheckHook,
  rich,
  setuptools,
  stdenv,
}:
buildPythonPackage rec {
  pname = "neoteroi-mkdocs";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "mkdocs-plugins";
    tag = "v${version}";
    hash = "sha256-4Rd4VhgaMzoSZ87FMQsUxadGG1ucQgGY0Y4uZoZl380=";
  };

  buildInputs = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    flask
    setuptools
  ];

  propagatedBuildInputs = [
    essentials-openapi
    click
    jinja2
    httpx
    mkdocs
    rich
  ];

  disabledTests = [
    "test_contribs" # checks against its own git repository
  ];

  pythonImportsCheck = [ "neoteroi.mkdocs" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests start a server using a hardcoded port, and since
    # multiple Python versions are always built simultaneously, this
    # failure is quite likely to occur.
    "tests/test_http.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/Neoteroi/mkdocs-plugins";
    description = "Plugins for MkDocs";
    changelog = "https://github.com/Neoteroi/mkdocs-plugins/releases/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      zimbatm
    ];
  };
}
