{
  lib,
  buildPythonPackage,
  cargo,
  fastimport,
  fetchFromGitHub,
  gevent,
  geventhttpclient,
  git,
  glibcLocales,
  gnupg,
  gpgme,
  merge3,
  openssh,
  paramiko,
  pytestCheckHook,
  rich,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  urllib3,
}:

buildPythonPackage rec {
  pname = "dulwich";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "dulwich";
    tag = "dulwich-${version}";
    hash = "sha256-7/aXxwK6LmERD8CSo+b1uuNVBrXcbBvksZ1YY28vB8A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-O35g5LflL8ZF0HNWdsqg1mp09dKFNrryz23G1WZhhPE=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [
    urllib3
  ];

  optional-dependencies = {
    colordiff = [ rich ];
    fastimport = [ fastimport ];
    https = [ urllib3 ];
    merge = [ merge3 ];
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
    openssh # for ssh-keygen
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # Depends on setuid which is not available in sandboxed environments
    "SharedRepositoryTests"
  ];

  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

  disabledTestPaths = [
    # "Code [in contrib] is not an official part of Dulwich, and may no longer work"
    "tests/contrib"
    # AssertionError: GPGMEError not raised
    "tests/test_signature.py::GPGSignatureVendorTests::test_verify_invalid_signature"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "dulwich" ];

  meta = {
    description = "Implementation of the Git file formats and protocols";
    longDescription = ''
      Dulwich is a Python implementation of the Git file formats and protocols, which
      does not depend on Git itself. All functionality is available in pure Python.
    '';
    homepage = "https://www.dulwich.io/";
    changelog = "https://github.com/jelmer/dulwich/blob/dulwich-${src.tag}/NEWS";
    license = with lib.licenses; [
      asl20
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      koral
      sarahec
    ];
  };
}
