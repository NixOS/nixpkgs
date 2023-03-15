{ lib
, buildPythonPackage
, fetchFromGitHub
, async-timeout
, docopt
, pyserial
, pyserial-asyncio
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.65";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    rev = "refs/tags/${version}";
    hash = "sha256-DUnhuA84nkmYkREa7vUiyLg7JUdEEeLewg3vFFlcar8=";
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
    changelog = "https://github.com/aequitas/python-rflink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
