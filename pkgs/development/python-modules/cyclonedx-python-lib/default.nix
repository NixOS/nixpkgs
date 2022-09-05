{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, jsonschema
, lxml
, packageurl-python
, poetry-core
, python
, pythonOlder
, requirements-parser
, sortedcontainers
, setuptools
, toml
, types-setuptools
, types-toml
, unittestCheckHook
, xmldiff
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "2.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-c/KhoJOa121/h0n0GUazjUFChnUo05ThD+fuZXc5/Pk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    importlib-metadata
    packageurl-python
    requirements-parser
    setuptools
    sortedcontainers
    toml
    types-setuptools
    types-toml
  ];

  checkInputs = [
    unittestCheckHook
    jsonschema
    lxml
    xmldiff
  ];

  pythonImportsCheck = [
    "cyclonedx"
  ];

  preCheck = ''
    rm tests/test_output_json.py
  '';

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
