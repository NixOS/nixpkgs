{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  importlib-resources,
  jsonpath-ng,
  jsonschema-specifications,
  pkgutil-resolve-name,
  pip,
  pytestCheckHook,
  pythonOlder,
  referencing,
  rpds-py,

  # optionals
  fqdn,
  idna,
  isoduration,
  jsonpointer,
  rfc3339-validator,
  rfc3986-validator,
  rfc3987,
  uri-template,
  webcolors,
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.25.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5jrPXBF2LA5mcv+2FIK99X8IdmhNjSScD+LXMNSLxV8=";
  };

  postPatch = ''
    patchShebangs json/bin/jsonschema_suite
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    attrs
    jsonpath-ng
    jsonschema-specifications
    referencing
    rpds-py
  ]
  ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
    pkgutil-resolve-name
  ];

  optional-dependencies = {
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
    pip
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jsonschema" ];

  meta = with lib; {
    description = "Implementation of JSON Schema validation";
    homepage = "https://github.com/python-jsonschema/jsonschema";
    changelog = "https://github.com/python-jsonschema/jsonschema/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "jsonschema";
  };
}
