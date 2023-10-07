{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, attrs
, isodate
, python-dateutil
, rfc3986
, uritemplate
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "csvw";
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "1393xwqawaxsflbq62vks92vv4zch8p6dd1mdvdi7j4vvf0zljkg";
  };

  propagatedBuildInputs = [
    attrs
    isodate
    python-dateutil
    rfc3986
    uritemplate
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  patchPhase = ''
    substituteInPlace setup.cfg \
      --replace "--cov" ""
  '';

  disabledTests = [
    # this test is flaky on darwin because it depends on the resolution of filesystem mtimes
    # https://github.com/cldf/csvw/blob/45584ad63ff3002a9b3a8073607c1847c5cbac58/tests/test_db.py#L257
    "test_write_file_exists"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/cldf/csvw/issues/58
    "test_roundtrip_escapechar"
    "test_escapequote_escapecharquotechar_final"
    "test_doubleQuote"
  ];

  pythonImportsCheck = [
    "csvw"
  ];

  meta = with lib; {
    description = "CSV on the Web";
    homepage = "https://github.com/cldf/csvw";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
