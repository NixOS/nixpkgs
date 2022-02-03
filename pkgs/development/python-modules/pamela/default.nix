{ lib
, buildPythonPackage
, fetchFromGitHub
, pkgs
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pamela";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "minrk";
    repo = pname;
    rev = version;
    hash = "sha256-eYO9ujXj5LT+fqSJy79Gw114THmdlA3/vnK5cK3h4zE=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postUnpack = ''
    substituteInPlace $sourceRoot/pamela.py --replace \
      'find_library("pam")' \
      '"${lib.getLib pkgs.pam}/lib/libpam.so"'
  '';

  disabledTests = [
    # Tests don't work in the sandbox
    "test_environment"
    "test_session"
  ];

  pythonImportsCheck = [
    "pamela"
  ];

  meta = with lib; {
    description = "PAM interface using ctypes";
    homepage = "https://github.com/minrk/pamela";
    license = licenses.mit;
    maintainers = with maintainers; [ ];

  };
}
