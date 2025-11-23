{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  dataclasses-json,
  fetchFromGitHub,
  htmlmin,
  jinja2,
  markdown2,
  poetry-core,
  pygments,
  pytestCheckHook,
  pytz,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "json-schema-for-humans";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = "json-schema-for-humans";
    tag = "v${version}";
    hash = "sha256-k4/+ijlaS/bjLcgobPcq6l4yX84WP1FwfGgYHw+iAdE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'markdown2 = "^2.5.0"' 'markdown2 = "^2.4.1"'
  '';

  pythonRelaxDeps = [ "dataclasses-json" ];

  build-system = [ poetry-core ];

  dependencies = [
    click
    dataclasses-json
    htmlmin
    jinja2
    markdown2
    pygments
    pytz
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_references_url"
    # Tests are failing
    "TestMdGenerate"
    # Broken since click was updated to 8.2.1 in https://github.com/NixOS/nixpkgs/pull/448189
    # Click 8.2 separates stdout and stderr, but upstream is on click 8.1 (https://github.com/pallets/click/pull/2523)
    "test_nonexistent_output_path"
    "test_config_parameters_with_nonexistent_output_path"
  ];

  pythonImportsCheck = [ "json_schema_for_humans" ];

  meta = with lib; {
    description = "Quickly generate HTML documentation from a JSON schema";
    homepage = "https://github.com/coveooss/json-schema-for-humans";
    changelog = "https://github.com/coveooss/json-schema-for-humans/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
    mainProgram = "generate-schema-doc";
  };
}
