{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  isodate,
  python-dateutil,
  rfc3986,
  uritemplate,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "csvw";
  version = "1.11.0";
  format = "setuptools";

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
    pytest-cov-stub
    pytest-mock
  ];

  disabledTests = [
    # this test is flaky on darwin because it depends on the resolution of filesystem mtimes
    # https://github.com/cldf/csvw/blob/45584ad63ff3002a9b3a8073607c1847c5cbac58/tests/test_db.py#L257
    "test_write_file_exists"
    # https://github.com/cldf/csvw/issues/58
    "test_roundtrip_escapechar"
    "test_escapequote_escapecharquotechar_final"
    "test_doubleQuote"
  ];

  pythonImportsCheck = [ "csvw" ];

  meta = {
    description = "CSV on the Web";
    homepage = "https://github.com/cldf/csvw";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
