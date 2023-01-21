{ lib
, buildPythonPackage
, fetchFromGitHub
, httpsig
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmartapp";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = pname;
    rev = version;
    sha256 = "sha256-zYjv7wRxQTS4PnNaY69bw9xE6I4DZMocwUzEICBfwqM=";
  };

  propagatedBuildInputs = [
    httpsig
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysmartapp"
  ];

  meta = with lib; {
    description = "Python implementation to work with SmartApp lifecycle events";
    homepage = "https://github.com/andrewsayre/pysmartapp";
    changelog = "https://github.com/andrewsayre/pysmartapp/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
