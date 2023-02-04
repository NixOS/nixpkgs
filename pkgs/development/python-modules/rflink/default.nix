{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, async-timeout
, docopt
, pyserial
, pyserial-asyncio
, setuptools
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.63";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    rev = "refs/tags/${version}";
    sha256 = "sha256-BNKcXtsBB90KQe4HXmfJ7H3yepk1dEkozSEy5v8KSAA=";
  };

  propagatedBuildInputs = [
    async-timeout
    docopt
    pyserial
    pyserial-asyncio
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/aequitas/python-rflink/issues/65
    "tests/test_proxy.py"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version_from_git()" "version='${version}'"
  '';

  pythonImportsCheck = [
    "rflink.protocol"
  ];

  meta = with lib; {
    description = "Library and CLI tools for interacting with RFlink 433MHz transceiver";
    homepage = "https://github.com/aequitas/python-rflink";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
