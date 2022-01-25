{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, jsonschema
, lxml
, packageurl-python
, poetry-core
, pytestCheckHook
, pythonOlder
, requirements-parser
, setuptools
, toml
, types-setuptools
, types-toml
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/1kWvhTUS0JT0RwodiivJSUiWIDwQyXxdjF/KUlCNds=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    importlib-metadata
    packageurl-python
    requirements-parser
    setuptools
    toml
    types-setuptools
    types-toml
  ];

  checkInputs = [
    jsonschema
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cyclonedx"
  ];

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
