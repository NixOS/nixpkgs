{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydevccu";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-rbxYTpB6ieZBYbbE1AKVEc/lapWlOUMOrSHCkuwkzLg=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pydevccu"
  ];

  meta = with lib; {
    description = "HomeMatic CCU XML-RPC Server with fake devices";
    homepage = "https://github.com/danielperna84/pydevccu";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
