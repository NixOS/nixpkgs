{ lib
, buildPythonPackage
, fetchFromGitHub
, pyaes
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crownstone-core";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-core";
    rev = version;
    sha256 = "138lignv7c8kkqbqfkdcfpg39gm9x44h7r2j403m4ib7gq420hsn";
  };

  propagatedBuildInputs = [
    pyaes
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "crownstone_core"
  ];

  meta = with lib; {
    description = "Python module with shared classes, util functions and definition of Crownstone";
    homepage = "https://github.com/crownstone/crownstone-lib-python-core";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
