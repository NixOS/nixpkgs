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

  disabledTests = [
    # Test assumes user name is part of $HOME
    # AssertionError: assert 'nixbld' in '/homeless-shelter/foo/bar'
    "test_strip_protocol_expanduser"
  ] ++ lib.optionals (stdenv.isDarwin) [
    "test_modified" # fails on hydra, works locally
    "test_touch" # fails on hydra, works locally
  ];

  meta = with lib; {
    description = "A specification that python filesystems should adhere to";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
