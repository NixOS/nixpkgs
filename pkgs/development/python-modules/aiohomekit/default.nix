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
  version = "0.2.61";
  format = "pyproject";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "047ql5a4i4354jgr8xr2waim8j522z58vbfi7aa62jqc9l8jzxzk";
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
