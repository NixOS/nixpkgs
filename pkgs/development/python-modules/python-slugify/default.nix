{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, text-unidecode
, unidecode
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "8.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "un33k";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MJac63XjgWdUQdyyEm8O7gAGVszmHxZzRF4frJtR0BU=";
  };

  propagatedBuildInputs = [
    text-unidecode
  ];

  passthru.optional-dependencies = {
    unidecode = [
      unidecode
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "slugify"
  ];

  meta = with lib; {
    description = "Python Slugify application that handles Unicode";
    homepage = "https://github.com/un33k/python-slugify";
    changelog = "https://github.com/un33k/python-slugify/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
