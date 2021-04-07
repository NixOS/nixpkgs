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
  version = "0.2.60";
  format = "pyproject";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "03llk5i22hq163x568kz0qar5h0sda8f8cxbmgya6z2dcxv0a83p";
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
