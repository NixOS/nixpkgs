{
  lib,
  attrs,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "headerparser";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "headerparser";
    tag = "v${version}";
    hash = "sha256-fn9Nlazte6r5JMmp9ynq0qmkLEoJGv8witgZlD7zJNM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    attrs
    deprecated
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "headerparser" ];

  meta = with lib; {
    description = "Module to parse key-value pairs in the style of RFC 822 (e-mail) headers";
    homepage = "https://github.com/jwodder/headerparser";
    changelog = "https://github.com/wheelodex/headerparser/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ayazhafiz ];
  };
}
