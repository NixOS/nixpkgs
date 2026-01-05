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
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "dulwich";
    tag = "dulwich-${version}";
    hash = "sha256-GGVvTKDLWPcx1f28Esl9sDXj33157NhSssYD/C+fLy4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-qGAvy0grueKI+A0nsXntf/EWtozSc138iFDhlfiktK8=";
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
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # AssertionError: 'C:\\\\foo.bar\\\\baz' != 'C:\\foo.bar\\baz'
    "test_file_win"
    # dulwich.errors.NotGitRepository: No git repository was found at .
    "WorktreeCliTests"
    # Adding a symlink to a directory outside the repo doesn't raise
    "test_add_symlink_absolute_to_system"
    # Depends on setuid which is not available in sandboxed environments
    "SharedRepositoryTests"
    # TypeError: pack index v1 only supports SHA-1 names
    "test_pack_index_v1_with_sha256"
  ];

  disabledTestPaths = [
    # "Code [in contrib] is not an official part of Dulwich, and may no longer work"
    "tests/contrib"
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
