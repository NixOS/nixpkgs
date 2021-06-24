{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "3.1.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = pname;
    rev = version;
    sha256 = "1skjwnqa3vcpq9gzgpw93wdmisq15fp0q07kzyq3fgx4yg7b6sql";
  };

  checkInputs = [
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

  pythonImportsCheck = [ "librouteros" ];

  meta = with lib; {
    description = "Python implementation of the MikroTik RouterOS API";
    homepage = "https://librouteros.readthedocs.io/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
