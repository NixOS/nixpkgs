{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.7.4";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "filesystem_spec";
    rev = version;
    sha256 = "0ylslmkzc803050yh8dl6cagabb9vrygz6w2zsmglzn4v9sz6jgd";
  };

  checkInputs = [
    pytestCheckHook
    numpy
  ];

  disabledTests = [
    # Test assumes user name is part of $HOME
    # AssertionError: assert 'nixbld' in '/homeless-shelter/foo/bar'
    "test_strip_protocol_expanduser"
  ];

  meta = with lib; {
    description = "A specification that python filesystems should adhere to";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
