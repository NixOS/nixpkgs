{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch2
, setuptools
, packaging
, tomli
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dparse";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J7uLS8rv7DmXaXuj9uBrJEcgC6JzwLCFw9ASoEVxtSg=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-configparser-deprecation-warning.patch";
      url = "https://github.com/pyupio/dparse/pull/69.patch";
      hash = "sha256-RolD6xDJpI8/UHgAdcsXoyxOGLok7AogLMOTl1ZPKvw=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    # FIXME pipenv = [ pipenv ];
    conda = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "dparse"
  ];

  disabledTests = [
    # requires unpackaged dependency pipenv
    "test_update_pipfile"
  ];

  meta = with lib; {
    description = "A parser for Python dependency files";
    homepage = "https://github.com/pyupio/dparse";
    changelog = "https://github.com/pyupio/dparse/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
