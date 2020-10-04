{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
, stdenv
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.8.3";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "filesystem_spec";
    rev = version;
    sha256 = "0mfy0wxjfwwnp5q2afhhfbampf0fk71wsv512pi9yvrkzzfi1hga";
  };

  checkInputs = [
    pytestCheckHook
    numpy
  ];

  pytestFlagsArray = [ "--rootdir=$(mktemp -d)" ];

  disabledTests = [
    # Test assumes user name is part of $HOME
    # AssertionError: assert 'nixbld' in '/homeless-shelter/foo/bar'
    "test_strip_protocol_expanduser"
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
