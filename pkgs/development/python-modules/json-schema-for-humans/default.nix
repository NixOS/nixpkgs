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
  pythonOlder,
  pytz,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "json-schema-for-humans";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = "json-schema-for-humans";
    tag = "v${version}";
    hash = "sha256-TmHqKf4/zzw3kImyYvnXsYJB7sL6RRs3vGCl8+Y+4BQ=";
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
