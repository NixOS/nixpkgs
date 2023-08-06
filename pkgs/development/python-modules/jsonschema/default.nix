{ lib
, attrs
, buildPythonPackage
, fetchPypi
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, importlib-metadata
, importlib-resources
, pkgutil-resolve-name
, pyrsistent
, pythonOlder
, twisted
, typing-extensions

# optionals
, fqdn
, idna
, isoduration
, jsonpointer
, rfc3339-validator
, rfc3986-validator
, rfc3987
, uri-template
, webcolors
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.17.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D4ZEN6uLYHa6ZwdFPvj5imoNUSqA6T+KvbZ29zfstg0=";
  };

  postPatch = ''
    patchShebangs json/bin/jsonschema_suite
  '';

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    pyrsistent
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
    pkgutil-resolve-name
  ];

  passthru.optional-dependencies = {
    format = [
      fqdn
      idna
      isoduration
      jsonpointer
      rfc3339-validator
      rfc3987
      uri-template
      webcolors
    ];
    format-nongpl = [
      fqdn
      idna
      isoduration
      jsonpointer
      rfc3339-validator
      rfc3986-validator
      uri-template
      webcolors
    ];
  };

  nativeCheckInputs = [
    twisted
  ];

  checkPhase = ''
    export JSON_SCHEMA_TEST_SUITE=json
    trial jsonschema
  '';

  pythonImportsCheck = [
    "jsonschema"
  ];

  meta = with lib; {
    description = "An implementation of JSON Schema validation for Python";
    homepage = "https://github.com/python-jsonschema/jsonschema";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
