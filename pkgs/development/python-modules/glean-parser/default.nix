{ lib
, appdirs
, buildPythonPackage
, click
, diskcache
, fetchPypi
, jinja2
, jsonschema
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools-scm
, yamllint
}:

buildPythonPackage rec {
  pname = "glean-parser";
  version = "6.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "glean_parser";
    inherit version;
    hash = "sha256-EqD+ztwRRNd/pXHgQi/z/qTbrcOB1jG+qACmsvWPT38=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" "" \
      --replace "MarkupSafe>=1.1.1,<=2.0.1" "MarkupSafe>=1.1.1"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    appdirs
    click
    diskcache
    jinja2
    jsonschema
    pyyaml
    yamllint
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Network access
    "test_validate_ping"
    # Fails since yamllint 1.27.x
    "test_yaml_lint"
  ];

  pythonImportsCheck = [
    "glean_parser"
  ];

  meta = with lib; {
    description = "Tools for parsing the metadata for Mozilla's glean telemetry SDK";
    homepage = "https://github.com/mozilla/glean_parser";
    license = licenses.mpl20;
    maintainers = with maintainers; [];
  };
}
