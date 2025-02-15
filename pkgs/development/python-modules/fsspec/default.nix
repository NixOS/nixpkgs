{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # optional-dependencies
  adlfs,
  pyarrow,
  dask,
  distributed,
  requests,
  dropbox,
  aiohttp,
  fusepy,
  gcsfs,
  libarchive-c,
  ocifs,
  panel,
  paramiko,
  pygit2,
  s3fs,
  smbprotocol,
  tqdm,

  # tests
  numpy,
  pytest-asyncio,
  pytest-mock,
  pytest-vcr,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "2025.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "filesystem_spec";
    tag = version;
    hash = "sha256-vJYnPbGbEMAe1p0EUBxSRZYtvBdJzjzDOesyTJsFJbU=";
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
    writableTmpDirAsHomeHook
  ];

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

  pythonImportsCheck = [ "fsspec" ];

  meta = {
    description = "Specification that Python filesystems should adhere to";
    homepage = "https://github.com/fsspec/filesystem_spec";
    changelog = "https://github.com/fsspec/filesystem_spec/raw/${version}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
