{ lib
, buildPythonPackage
, fetchFromGitHub
, httpsig
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysmartapp";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = pname;
    rev = version;
    sha256 = "03wk44siqxl15pa46x5vkg4q0mnga34ir7qn897576z2ivbx7awh";
  };

  propagatedBuildInputs = [
    httpsig
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysmartapp" ];

  meta = with lib; {
    description = "Python implementation to work with SmartApp lifecycle events";
    homepage = "https://github.com/andrewsayre/pysmartapp";
    changelog = "https://github.com/andrewsayre/pysmartapp/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
