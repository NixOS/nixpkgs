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
  version = "0.44";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LsZPf5PVXPSyHNgfBdjH4hG4OFIdSprO5uj3saPDqzo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pytz = "^2021.1"' 'pytz = "*"'
  '';

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
