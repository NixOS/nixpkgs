{ lib
, beautifulsoup4
, buildPythonPackage
, click
, dataclasses-json
, fetchFromGitHub
, htmlmin
, jinja2
, markdown2
, pbr
, pygments
, pytestCheckHook
, pytz
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "json-schema-for-humans";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "v${version}";
    sha256 = "1aj1w0qxdw8d6mf5vngk0xjgs7z8vzwc2aycahnkqg7q3cagq19n";
  };

  nativeBuildInputs = [ pbr ];

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

  preBuild = ''
    export PBR_VERSION=0.0.1
  '';

  checkInputs = [
    beautifulsoup4
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_references_url"
  ];

  pythonImportsCheck = [ "json_schema_for_humans" ];

  meta = with lib; {
    description = "Quickly generate HTML documentation from a JSON schema";
    homepage = "https://github.com/coveooss/json-schema-for-humans";
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
