{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, setuptools
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
  version = "3.5.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
    sha256 = "sha256-AZ9M/NBCBlMIUpRJgKbJRL/oReZDUh2Jhwtoxoo0tMs=";
  };

  patches = [
    (fetchpatch {
      # Pytest 7.0 compatibility
      url = "https://github.com/agronholm/anyio/commit/fed7cc4f95e196f68251bcb9253da3b143ea8e7e.patch";
      sha256 = "sha256-VmZmiQEmWJ4aPz0Wx+GTMZo7jXRDScnRYf2Hu2hiRVw=";
    })
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION=${version}
  '';

  nativeBuildInputs = [
    setuptools
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

  disabledTests = [
    # block devices access
    "test_is_block_device"
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
