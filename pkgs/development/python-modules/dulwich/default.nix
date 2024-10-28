{
  lib,
  stdenv,
  buildPythonPackage,
  fastimport,
  fetchFromGitHub,
  fetchpatch2,
  gevent,
  geventhttpclient,
  git,
  glibcLocales,
  gnupg,
  gpgme,
  paramiko,
  unittestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-rust,
  urllib3,
}:

buildPythonPackage rec {
  version = "0.22.2";
  pname = "dulwich";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "dulwich";
    rev = "refs/tags/dulwich-${version}";
    hash = "sha256-yM1U8DowevtZt6qqSybur7xmwRnlJ0rwV0qJfQf+ZIs=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [
    urllib3
  ];

  optional-dependencies = {
    fastimport = [ fastimport ];
    https = [ urllib3 ];
    pgp = [
      gpgme
      gnupg
    ];
    paramiko = [ paramiko ];
  };

  nativeCheckInputs =
    [
      gevent
      git
      glibcLocales
      unittestCheckHook
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies)
    ++ lib.optionals (pythonOlder "3.13") [ geventhttpclient ];

  preCheck = ''
    # requires swift config file
    rm tests/contrib/test_swift_smoke.py

    # ImportError: attempted relative import beyond top-level package
    rm tests/test_greenthreads.py
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

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
