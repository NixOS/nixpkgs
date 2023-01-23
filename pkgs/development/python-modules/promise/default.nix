{ buildPythonPackage
, fetchFromGitHub
, lib
, six
, pytestCheckHook
, mock
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "promise";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "syrusakbary";
    repo = "promise";
    rev = "v${version}";
    sha256 = "17mq1bm78xfl0x1g50ng502m5ldq6421rzz35hlqafsj0cq8dkp6";
  };

  postPatch = ''
    substituteInPlace tests/test_extra.py \
      --replace "assert_exc.traceback[-1].path.strpath" "str(assert_exc.traceback[-1].path)"
  '';

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pytest-asyncio
  ];

  disabledTestPaths = [
    "tests/test_benchmark.py"
  ];

  meta = with lib; {
    description = "Ultra-performant Promise implementation in Python";
    homepage = "https://github.com/syrusakbary/promise";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
