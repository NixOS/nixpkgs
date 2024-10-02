{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "2024.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "filesystem_spec";
    rev = "refs/tags/${version}";
    hash = "sha256-C+47BcIELZTEARXW8fAMHMjyKUWxU1tNKWGoPPtt/fQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    paramiko
    requests
    smbprotocol
    tqdm
  ];

  optional-dependencies = {
    entrypoints = [ ];
    abfs = [ adlfs ];
    adl = [ adlfs ];
    dask = [
      dask
      distributed
    ];
    dropbox = [
      # missing dropboxdrivefs
      requests
      dropbox
    ];
    gcs = [ gcsfs ];
    git = [ pygit2 ];
    github = [ requests ];
    gs = [ gcsfs ];
    hdfs = [ pyarrow ];
    arrow = [ pyarrow ];
    http = [
      aiohttp
      requests
    ];
    sftp = [ paramiko ];
    s3 = [ s3fs ];
    oci = [ ocifs ];
    smb = [ smbprotocol ];
    ssh = [ paramiko ];
    fuse = [ fusepy ];
    libarchive = [ libarchive-c ];
    gui = [ panel ];
    tqdm = [ tqdm ];
  };

  nativeCheckInputs = [
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
      # this two tests however, assume nanosecond resolution
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

  meta = with lib; {
    description = "Specification that Python filesystems should adhere to";
    homepage = "https://github.com/fsspec/filesystem_spec";
    changelog = "https://github.com/fsspec/filesystem_spec/raw/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
