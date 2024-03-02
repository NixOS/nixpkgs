{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, ftfy
, mailchecker
, openpyxl
, orjson
, phonenumbers
, beautifulsoup4
, pytestCheckHook
, python-dateutil
, python-decouple
, python-fsutil
, python-slugify
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, requests
, setuptools
, toml
, xlrd
, xmltodict
}:

buildPythonPackage rec {
  pname = "python-benedict";
  version = "0.33.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "python-benedict";
    rev = "refs/tags/${version}";
    hash = "sha256-QRWyMqHW4C3+718mgp9z/dQ1loesm0Vaf2TzW3yqF3A=";
  };

  pythonRelaxDeps = [
    "boto3"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    python-fsutil
    python-slugify
    requests
  ];

  passthru.optional-dependencies = {
    all = [
      beautifulsoup4
      boto3
      ftfy
      mailchecker
      openpyxl
      phonenumbers
      python-dateutil
      pyyaml
      toml
      xlrd
      xmltodict
    ];
    html = [
      beautifulsoup4
      xmltodict
    ];
    io = [
      beautifulsoup4
      openpyxl
      pyyaml
      toml
      xlrd
      xmltodict
    ];
    parse = [
      ftfy
      mailchecker
      phonenumbers
      python-dateutil
    ];
    s3 = [
      boto3
    ];
    toml = [
      toml
    ];
    xls = [
      openpyxl
      xlrd
    ];
    xml = [
      xmltodict
    ];
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    orjson
    pytestCheckHook
    python-decouple
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # Tests require network access
    "test_from_base64_with_valid_url_valid_content"
    "test_from_html_with_valid_file_valid_content"
    "test_from_html_with_valid_url_valid_content"
    "test_from_json_with_valid_url_valid_content"
    "test_from_pickle_with_valid_url_valid_content"
    "test_from_plist_with_valid_url_valid_content"
    "test_from_query_string_with_valid_url_valid_content"
    "test_from_toml_with_valid_url_valid_content"
    "test_from_xls_with_valid_url_valid_content"
    "test_from_xml_with_valid_url_valid_content"
    "test_from_yaml_with_valid_url_valid_content"
  ];

  pythonImportsCheck = [
    "benedict"
  ];

  meta = with lib; {
    description = "Module with keylist/keypath support";
    homepage = "https://github.com/fabiocaccamo/python-benedict";
    changelog = "https://github.com/fabiocaccamo/python-benedict/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
