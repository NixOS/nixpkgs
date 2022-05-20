{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
, aiohttp
, pytest-vcr
, pytest-mock
, pytest-asyncio
, requests
, paramiko
, smbprotocol
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "2022.3.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "filesystem_spec";
    rev = version;
    sha256 = "sha256-jTF8R0kaHMsCYg+7YFi21Homn63K+ulp9NDZC/jkIXM=";
  };

  propagatedBuildInputs = [
    aiohttp
    paramiko
    requests
    smbprotocol
  ];

  checkInputs = [
    numpy
    pytest-vcr
    pytest-mock
    pytest-asyncio
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

  pythonImportsCheck = [ "fsspec" ];

  meta = with lib; {
    homepage = "https://github.com/intake/filesystem_spec";
    description = "A specification that Python filesystems should adhere to";
    changelog = "https://github.com/fsspec/filesystem_spec/raw/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
