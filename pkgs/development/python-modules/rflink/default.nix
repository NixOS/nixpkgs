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

  patches = [
    # https://github.com/aequitas/python-rflink/pull/70
    (fetchpatch {
      name = "python311-compat.patch";
      url = "https://github.com/aequitas/python-rflink/commit/ba807ddd2fde823b8d50bc50bb500a691d9e331f.patch";
      hash = "sha256-4Wh7b7j8qsvzYKdFwaY+B5Jd8EkyjAe1awlY0BDu2YA=";
    })
  ];

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
