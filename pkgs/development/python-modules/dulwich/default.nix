{
  lib,
  stdenv,
  buildPythonPackage,
  certifi,
  fastimport,
  fetchFromGitHub,
  gevent,
  geventhttpclient,
  git,
  glibcLocales,
  gnupg,
  gpgme,
  paramiko,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-rust,
  urllib3,
}:

buildPythonPackage rec {
  version = "0.21.7";
  pname = "dulwich";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "dulwich";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-iP+6KtaQ8tfOobovSLSJZogS/XWW0LuHgE2oV8uQW/8=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  passthru.optional-dependencies = {
    fastimport = [ fastimport ];
    pgp = [
      gpgme
      gnupg
    ];
    paramiko = [ paramiko ];
  };

  nativeCheckInputs =
    [
      gevent
      geventhttpclient
      git
      glibcLocales
      pytest-xdist
      pytestCheckHook
    ]
    ++ passthru.optional-dependencies.fastimport
    ++ passthru.optional-dependencies.pgp
    ++ passthru.optional-dependencies.paramiko;

  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character: b'/build/tmpsqwlbpd1/\xc0'
    "test_no_decode_encode"
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character: b'/build/tmpwmtfyvo2/refs.git/refs/heads/\xcd\xee\xe2\xe0\xff\xe2\xe5\xf2\xea\xe01'
    "test_cyrillic"
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character: b'/build/tmpfseetobk/test/\xc0'
    "test_commit_no_encode_decode"
    # https://github.com/jelmer/dulwich/issues/1279
    "test_init_connector"
  ];

  disabledTestPaths = [
    # missing test inputs
    "dulwich/contrib/test_swift_smoke.py"
    # flaky on high core count >4
    "dulwich/tests/compat/test_client.py"
  ];

  pythonImportsCheck = [ "dulwich" ];

  meta = with lib; {
    description = "Implementation of the Git file formats and protocols";
    longDescription = ''
      Dulwich is a Python implementation of the Git file formats and protocols, which
      does not depend on Git itself. All functionality is available in pure Python.
    '';
    homepage = "https://www.dulwich.io/";
    changelog = "https://github.com/jelmer/dulwich/blob/dulwich-${version}/NEWS";
    license = with licenses; [
      asl20
      gpl2Plus
    ];
    maintainers = with maintainers; [ koral ];
  };
}
