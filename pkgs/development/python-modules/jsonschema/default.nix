{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  jsonpath-ng,
  jsonschema-specifications,
  pip,
  pytestCheckHook,
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
  rfc3987-syntax,
  uri-template,
  webcolors,
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.25.0";
  pyproject = true;

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
      rfc3987-syntax
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
    maintainers = [ ];
    mainProgram = "jsonschema";
  };
}
