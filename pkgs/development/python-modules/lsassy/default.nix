{ lib
, buildPythonPackage
, fetchFromGitHub
, impacket
, netaddr
, pythonOlder
, pypykatz
, rich
}:

buildPythonPackage rec {
  pname = "lsassy";
  version = "3.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/YDBzH8Mji6PWBEIbsgZcTvoAWAsBbJV3cHfySY/gGA=";
  };

  propagatedBuildInputs = [
    impacket
    netaddr
    pypykatz
    rich
  ];

  # Tests require an active domain controller
  doCheck = false;

  pythonImportsCheck = [
    "lsassy"
  ];

  meta = with lib; {
    description = "Python module to extract data from Local Security Authority Subsystem Service (LSASS)";
    homepage = "https://github.com/Hackndo/lsassy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
