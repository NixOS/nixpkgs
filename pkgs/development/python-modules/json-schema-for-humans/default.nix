{ lib
, beautifulsoup4
, buildPythonPackage
, click
, dataclasses-json
, fetchFromGitHub
, htmlmin
, jinja2
, markdown2
, poetry-core
, pygments
, pytestCheckHook
, pythonOlder
, pytz
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "json-schema-for-humans";
  version = "0.46";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wTO+d0O3SKT2jJ2zNubT2q76PdJ7+kT9RBEw5MMH1yg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "json_schema_for_humans"
  ];

  meta = with lib; {
    description = "Quickly generate HTML documentation from a JSON schema";
    homepage = "https://github.com/coveooss/json-schema-for-humans";
    changelog = "https://github.com/coveooss/json-schema-for-humans/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
