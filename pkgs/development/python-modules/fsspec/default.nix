{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
, stdenv
, aiohttp
, pytest-vcr
, requests
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "2021.04.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "filesystem_spec";
    rev = version;
    sha256 = "sha256-9072kb1VEQ0xg9hB8yEzJMD2Ttd3UGjBmTuhE+Uya1k=";
  };

  checkInputs = [ pytestCheckHook numpy pytest-vcr ];

  __darwinAllowLocalNetworking = true;

  propagatedBuildInputs = [ aiohttp requests ];

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

  meta = with lib; {
    description = "A specification that python filesystems should adhere to";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
