{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "3.2.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = pname;
    rev = version;
    sha256 = "sha256-VwpZ1RY6Sul7xvWY7ZoOxZ7KgbRmKRwcVdF9e2b3f6Q=";
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests which require QEMU to run
    "test_login"
    "test_long_word"
    "test_query"
    "test_add_then_remove"
    "test_add_then_update"
    "test_generator_ditch"
  ];

  pythonImportsCheck = [
    "librouteros"
  ];

  meta = with lib; {
    description = "Python implementation of the MikroTik RouterOS API";
    homepage = "https://librouteros.readthedocs.io/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
