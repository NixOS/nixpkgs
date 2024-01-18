{ lib
, attrs
, buildPythonPackage
, deprecated
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "headerparser";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "headerparser";
    rev = "refs/tags/v${version}";
    hash = "sha256-CWXha7BYVO5JFuhWP8OZ95fhUsZ3Jo0cgPAM+O5bfec=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    deprecated
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "headerparser"
  ];

  meta = with lib; {
    description = "Module to parse key-value pairs in the style of RFC 822 (e-mail) headers";
    homepage = "https://github.com/jwodder/headerparser";
    changelog = "https://github.com/wheelodex/headerparser/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ayazhafiz ];
  };
}
