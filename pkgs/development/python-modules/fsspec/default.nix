{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  numpy,
  paramiko,
  pytest-asyncio,
  pytest-mock,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  requests,
  smbprotocol,
  tqdm,
  adlfs,
  dask,
  distributed,
  dropbox,
  fusepy,
  gcsfs,
  libarchive-c,
  ocifs,
  panel,
  pyarrow,
  pygit2,
  s3fs,
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "2024.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "filesystem_spec";
    tag = version;
    hash = "sha256-Vc0vBayPg6zZ4+pxJsHChSGg0kjA0Q16+Gk0bO0IEpI=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  optional-dependencies = {
    abfs = [ adlfs ];
    adl = [ adlfs ];
    arrow = [ pyarrow ];
    dask = [
      dask
      distributed
    ];
    dropbox = [
      # missing dropboxdrivefs
      requests
      dropbox
    ];
    entrypoints = [ ];
    full = [
      adlfs
      aiohttp
      dask
      distributed
      dropbox
      # dropboxdrivefs
      fusepy
      gcsfs
      libarchive-c
      ocifs
      panel
      paramiko
      pyarrow
      pygit2
      requests
      s3fs
      smbprotocol
      tqdm
    ];
    fuse = [ fusepy ];
    gcs = [ gcsfs ];
    git = [ pygit2 ];
    github = [ requests ];
    gs = [ gcsfs ];
    gui = [ panel ];
    hdfs = [ pyarrow ];
    http = [
      aiohttp
      requests
    ];
    libarchive = [ libarchive-c ];
    oci = [ ocifs ];
    s3 = [ s3fs ];
    sftp = [ paramiko ];
    smb = [ smbprotocol ];
    ssh = [ paramiko ];
    tqdm = [ tqdm ];
  };

  nativeCheckInputs = [
    aiohttp
    numpy
    pytest-asyncio
    pytest-mock
    pytest-vcr
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  __darwinAllowLocalNetworking = true;

  disabledTests =
    [
      # Test assumes user name is part of $HOME
      # AssertionError: assert 'nixbld' in '/homeless-shelter/foo/bar'
      "test_strip_protocol_expanduser"
      # test accesses this remote ftp server:
      # https://ftp.fau.de/debian-cd/current/amd64/log/success
      "test_find"
      # Tests want to access S3
      "test_urlpath_inference_errors"
      "test_mismatch"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # works locally on APFS, fails on hydra with AssertionError comparing timestamps
      # darwin hydra builder uses HFS+ and has only one second timestamp resolution
      # this two tests however, assume nanosecond resolution
      "test_modified"
      "test_touch"
      # tries to access /home, ignores $HOME
      "test_directories"
    ];

  disabledTestPaths = [
    # JSON decoding issues
    "fsspec/implementations/tests/test_dbfs.py"
  ];

  pythonImportsCheck = [ "fsspec" ];

  meta = {
    description = "Specification that Python filesystems should adhere to";
    homepage = "https://github.com/fsspec/filesystem_spec";
    changelog = "https://github.com/fsspec/filesystem_spec/raw/${version}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
