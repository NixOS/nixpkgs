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
  version = "4.3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wZSro1pX/50TlSfFMh71JlmXlJlONVutTDFL06tkw+s=";
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
