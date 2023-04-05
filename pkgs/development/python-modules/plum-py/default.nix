{ lib
, buildPythonPackage
, fetchFromGitLab
, isPy3k
, pytestCheckHook
, baseline
}:

buildPythonPackage rec {
  pname = "plum-py";
  version = "0.8.5";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    owner = "dangass";
    repo = "plum";
    rev = version;
    hash = "sha256-jCZUNT1HpSr0khHsjnxEzN2LCzcDV6W27PjVkwFJHUg=";
  };

  postPatch = ''
    # Drop broken version specifier
    sed -i "/python_requires =/d" setup.cfg
  '';

  pythonImportsCheck = [ "plum" ];

  nativeCheckInputs = [
    baseline
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests"
  ];

  meta = with lib; {
    description = "Classes and utilities for packing/unpacking bytes";
    homepage = "https://plum-py.readthedocs.io/en/latest/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
