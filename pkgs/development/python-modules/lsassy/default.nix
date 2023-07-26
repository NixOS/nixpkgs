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
  version = "3.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-refOq/QWRv1naCskVm6h1QmCH9/YkDJ90HU3Hzc2w4A=";
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
    changelog = "https://github.com/Hackndo/lsassy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
