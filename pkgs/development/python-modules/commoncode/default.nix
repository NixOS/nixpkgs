{ lib
, stdenv
, attrs
, beautifulsoup4
, buildPythonPackage
, click
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "nexB";
     repo = "commoncode";
     rev = "v30.0.0";
     sha256 = "07s9qijnrzk2jpc0gzzg4p7ig7kxp7f2pp11prf5mvk74wc1bzbn";
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
