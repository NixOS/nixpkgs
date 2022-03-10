{ lib
, beautifulsoup4
, buildPythonPackage
, click
, dataclasses
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
  version = "0.40";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-H0jvOnrWE4/xxRYNehshHBRNc/qLX1+sCV7O1ACCdew=";
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
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    beautifulsoup4
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/coveooss/json-schema-for-humans/issues/127
    substituteInPlace pyproject.toml \
      --replace 'PyYAML = "^5.4.1"' 'PyYAML = "*"'
  '';

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
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
