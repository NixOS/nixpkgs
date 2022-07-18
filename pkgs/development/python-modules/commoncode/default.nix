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
, pythonAtLeast
, pythonOlder
, requests
, saneyaml
, setuptools-scm
, text-unidecode
, typing
}:

buildPythonPackage rec {
  pname = "commoncode";
  version = "30.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7kcDWfw4M7boe0ABO4ob1d+XO1YxS924mtGETvHoNf0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "intbitset >= 2.3.0, < 3.0" "intbitset >= 2.3.0"
  '';

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

  disabledTestPaths = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/nexB/commoncode/issues/36
    "src/commoncode/fetch.py"
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
