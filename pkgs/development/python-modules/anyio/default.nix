{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
, idna
, sniffio
, typing-extensions
, curio
, hypothesis
, mock
, pytest-mock
, pytestCheckHook
, trio
, trustme
, uvloop
}:

buildPythonPackage rec {
  pname = "anyio";
  version = "3.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
    sha256 = "sha256-zQiSAQN7cp1s+8hDTvYaMkHUXV1ccNwIsl2IOztH7J8=";
  };

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION=${version}
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    idna
    sniffio
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    curio
    hypothesis
    pytest-mock
    pytestCheckHook
    trio
    trustme
    uvloop
  ] ++ lib.optionals (pythonOlder "3.8") [
    mock
  ];

  disabledTestPaths = [
     # lots of DNS lookups
    "tests/test_sockets.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin sandboxing limitations
    "tests/streams/test_tls.py"
  ];

  pythonImportsCheck = [ "anyio" ];

  meta = with lib; {
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
