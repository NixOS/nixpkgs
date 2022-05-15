{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyschemes";
  version = "unstable-2017-11-08";
  format = "setuptools";

  disabled = pythonAtLeast "3.10";

  src = fetchFromGitHub {
    owner = "spy16";
    repo = pname;
    rev = "ca6483d13159ba65ba6fc2f77b90421c40f2bbf2";
    hash = "sha256-PssucudvlE8mztwVme70+h+2hRW/ri9oV9IZayiZhdU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyschemes" ];

  meta = with lib; {
    description = "A library for validating data structures in Python";
    homepage = "https://github.com/spy16/pyschemes";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ gador ];
  };
}
