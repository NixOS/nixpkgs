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
, setuptools
, toml
, types-setuptools
, types-toml
, xmldiff
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QylA3bf0P65prR74H5+Sm51xWjjhOYpe4jHX7m/f6mI=";
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
    xmldiff
  ];

  pythonImportsCheck = [
    "cyclonedx"
  ];

 checkPhase = ''
   runHook preCheck
   # Tests require network access
   rm tests/test_output_json.py
   ${python.interpreter} -m unittest discover -s tests -v
   runHook postCheck
 '';

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
