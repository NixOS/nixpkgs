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
  pname = "dulwich";
  version = "0.22.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "dulwich";
    rev = "refs/tags/${version}";
    hash = "sha256-bf3ZUMX4afpdTBpFnx0HMyzCNG6V/p4eOl36djxGbtk=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [
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

  nativeCheckInputs = [
    gevent
    geventhttpclient
    git
    glibcLocales
    pytest-xdist
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  doCheck = !stdenv.isDarwin;

  disabledTestPaths = [
    # Missing test inputs
    "tests/contrib/test_swift_smoke.py"
    # Import issue
    "tests/test_greenthreads.py"
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
