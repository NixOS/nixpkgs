{ lib
, stdenv
, attrs
, beautifulsoup4
, buildPythonPackage
, click
, fetchPypi
, intbitset
, pytest-xdist
, pytestCheckHook
, pythonOlder
, requests
, saneyaml
, setuptools-scm
, text-unidecode
, typing
}:

buildPythonPackage rec {
  pname = "commoncode";
  version = "30.0.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6SeU4u6pfDuGCgCYAO5fdbWBxW9XN3WvM8j6DwUlFwM=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    beautifulsoup4
    click
    intbitset
    requests
    saneyaml
    text-unidecode
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];
  disabledTests = lib.optionals stdenv.isDarwin [
    # expected result is tailored towards the quirks of upstream's
    # CI environment on darwin
    "test_searchable_paths"
  ];

  pythonImportsCheck = [
    "commoncode"
  ];

  meta = with lib; {
    description = "A set of common utilities, originally split from ScanCode";
    homepage = "https://github.com/nexB/commoncode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
