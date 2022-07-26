{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, ftfy
, mailchecker
, orjson
, phonenumbers
, pytestCheckHook
, python-dateutil
, python-fsutil
, pythonOlder
, python-slugify
, pyyaml
, requests
, six
, toml
, xmltodict
}:

buildPythonPackage rec {
  pname = "python-benedict";
  version = "0.25.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WSsT+p23VctVt9A+WFKNHcgUHFijfT775eMF3RzaXDA=";
  };

  propagatedBuildInputs = [
    mailchecker
    phonenumbers
    python-dateutil
    python-fsutil
    python-slugify
    pyyaml
    ftfy
    orjson
    requests
    six
    toml
    xmltodict
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_from_base64_with_valid_url_valid_content"
    "test_from_json_with_valid_url_valid_content"
    "test_from_pickle_with_valid_url_valid_content"
    "test_from_plist_with_valid_url_valid_content"
    "test_from_query_string_with_valid_url_valid_content"
    "test_from_toml_with_valid_url_valid_content"
    "test_from_xml_with_valid_url_valid_content"
    "test_from_yaml_with_valid_url_valid_content"
  ];

  pythonImportsCheck = [
    "benedict"
  ];

  meta = with lib; {
    description = "Module with keylist/keypath support";
    homepage = "https://github.com/fabiocaccamo/python-benedict";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
