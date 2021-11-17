{ lib
, pkgs
, python3Packages
, setuptools-scm
}:

python3Packages.buildPythonPackage rec {
  pname = "glean_parser";
  version = "4.3.1";

  disabled = python3Packages.pythonOlder "3.6";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-wZSro1pX/50TlSfFMh71JlmXlJlONVutTDFL06tkw+s=";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    click
    diskcache
    jinja2
    jsonschema
    pytest
    pytest-runner
    pyyaml
    yamllint
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
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
