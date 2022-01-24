{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
# build inputs
, appdirs
, click
, diskcache
, jinja2
, jsonschema
, pyyaml
, yamllint
}:

buildPythonPackage rec {
  pname = "glean_parser";
  version = "4.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ae1435b183936a49368806421df27ab944f1802e86a02b38b8e08e53ff0aac5";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    appdirs
    click
    diskcache
    jinja2
    jsonschema
    pyyaml
    yamllint
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];
  disabledTests = [
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1741668
    "test_validate_ping"
  ];

  pythonImportsCheck = [ "glean_parser" ];

  meta = with lib; {
    description = "Tools for parsing the metadata for Mozilla's glean telemetry SDK";
    homepage = "https://github.com/mozilla/glean_parser";
    license = licenses.mpl20;
    maintainers = [ maintainers.kvark ];
  };
}
