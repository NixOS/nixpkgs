{
  buildPythonPackage,
  drf-jwt,
  faker,
  fetchFromGitHub,
  jsonschema,
  lib,
  mypy,
  nix-update-script,
  pydantic,
  pytestCheckHook,
  requests,
  rstr,
  setuptools,
  smart-open,
  typer-slim,
}:

buildPythonPackage rec {
  pname = "jsf";
  version = "0.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ghandic";
    repo = "jsf";
    tag = "v${version}";
    hash = "sha256-sjINQpvu25wezR0vGpVMLWLMMYnxGkI/u1a2lny4b7o=";
  };

  build-system = [ mypy ];

  dependencies = [
    faker
    jsonschema
    pydantic
    rstr
    setuptools
    smart-open
  ];

  nativeCheckInputs = [
    drf-jwt
    pytestCheckHook
    requests
    typer-slim
  ];

  # switch to pantsbuild if it becomes available
  prePatch = ''
        cat >> pyproject.toml << EOF
    [project]
      name = "jsf"
      version = "${version}"
    [tool.setuptools.packages]
      find = {}
    EOF
  '';

  disabledTests = [
    # require online connection
    "test_fake_string_content_type"
    "test_external_ref"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Creates fake JSON files from a JSON schema";
    homepage = "https://github.com/ghandic/jsf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/ghandic/jsf/releases/tag/${src.tag}";
  };
}
