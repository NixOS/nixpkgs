{
  lib,
  bleak,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pykulersky";
  version = "0.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    hash = "sha256-coO+WBnv5HT14ym719qr3Plm1JuiaNdAvD1QVPj65oU=";
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

  pythonImportsCheck = [ "pykulersky" ];

  meta = with lib; {
    description = "Python module to control Brightech Kuler Sky Bluetooth LED devices";
    mainProgram = "pykulersky";
    homepage = "https://github.com/emlove/pykulersky";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
