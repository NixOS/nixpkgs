{ lib
, stdenv
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, numpy
, paramiko
, pytest-asyncio
, pytest-mock
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, smbprotocol
, tqdm
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "2022.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "filesystem_spec";
    rev = version;
    hash = "sha256-WOzw9UPF8LZuOhp5p/CJUUJcYpAfixV6GiI8tfnoklc=";
  };

  propagatedBuildInputs = [
    aiohttp
    paramiko
    requests
    smbprotocol
    tqdm
  ];

  checkInputs = [
    numpy
    pytest-asyncio
    pytest-mock
    pytest-vcr
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # Test assumes user name is part of $HOME
    # AssertionError: assert 'nixbld' in '/homeless-shelter/foo/bar'
    "test_strip_protocol_expanduser"
    # test accesses this remote ftp server:
    # https://ftp.fau.de/debian-cd/current/amd64/log/success
    "test_find"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # works locally on APFS, fails on hydra with AssertionError comparing timestamps
    # darwin hydra builder uses HFS+ and has only one second timestamp resolution
    # this two tests however, assume nanosecond resolution
    "test_modified"
    "test_touch"
  ];

  pythonImportsCheck = [
    "fsspec"
  ];

  meta = with lib; {
    description = "A specification that Python filesystems should adhere to";
    homepage = "https://github.com/intake/filesystem_spec";
    changelog = "https://github.com/fsspec/filesystem_spec/raw/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
