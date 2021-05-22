{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, poetry
, pytest-aiohttp
, pytestCheckHook
, pythonAtLeast
, zeroconf
}:

buildPythonPackage rec {
  pname = "aiohomekit";
  version = "0.2.62";
  format = "pyproject";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "sha256-01IzeR0iukPTkz8I7h93wZkgjz6flRAJN8unEX6d+cs=";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    cryptography
    zeroconf
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  # Some test requires network access
  disabledTests = [
    "test_remove_pairing"
    "test_pair"
    "test_add_and_remove_pairings"
  ];

  pythonImportsCheck = [ "aiohomekit" ];

  meta = with lib; {
    description = "Python module that implements the HomeKit protocol";
    longDescription = ''
      This Python library implements the HomeKit protocol for controlling
      Homekit accessories.
    '';
    homepage = "https://github.com/Jc2k/aiohomekit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
