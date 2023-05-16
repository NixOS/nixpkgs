{ lib
, attrs
, buildPythonPackage
, fetchPypi
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
<<<<<<< HEAD
, importlib-resources
, jsonschema-specifications
, pkgutil-resolve-name
, pip
, pytestCheckHook
, pythonOlder
, referencing
, rpds-py
=======
, importlib-metadata
, importlib-resources
, pyrsistent
, pythonOlder
, twisted
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
  version = "4.18.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+zZCc1OZ+pWMDSqtcFeQFVRZbGM0n09rKDxJPPaSol0=";
=======
  version = "4.17.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D4ZEN6uLYHa6ZwdFPvj5imoNUSqA6T+KvbZ29zfstg0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    jsonschema-specifications
    referencing
    rpds-py
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
    pkgutil-resolve-name
=======
    pyrsistent
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pip
    pytestCheckHook
  ];

=======
    twisted
  ];

  checkPhase = ''
    export JSON_SCHEMA_TEST_SUITE=json
    trial jsonschema
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "jsonschema"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "An implementation of JSON Schema validation";
=======
    description = "An implementation of JSON Schema validation for Python";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/python-jsonschema/jsonschema";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
