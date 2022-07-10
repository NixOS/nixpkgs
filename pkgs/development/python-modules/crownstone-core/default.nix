{ lib
, buildPythonPackage
, fetchFromGitHub
, pyaes
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crownstone-core";
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-core";
    rev = version;
    sha256 = "sha256-SdrvJE76/UrwcJ2Os1WO9cv9++LKu4eKRn1W4qrK8Lw=";
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
