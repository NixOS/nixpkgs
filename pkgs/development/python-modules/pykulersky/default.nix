{ lib
, bleak
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pykulersky";
  version = "0.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "sha256-voD4tR+k5TKGjLXFK94GJy4+wUoP2cSFc5BWkCiinOg=";
  };

  propagatedBuildInputs = [
    bleak
    click
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pykulersky"
  ];

  meta = with lib; {
    description = "Python module to control Brightech Kuler Sky Bluetooth LED devices";
    homepage = "https://github.com/emlove/pykulersky";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
