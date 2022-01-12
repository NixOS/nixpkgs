{ lib
, buildPythonPackage
, fetchFromGitHub
, pysnmp
, pytest-asyncio
, pytest-error-for-skips
, pytest-runner
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "brother";
  version = "1.1.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZDQIpzdr3XkYrSUgrBDZsUwUZRQCdJdvmniMezvJxzU=";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov --cov-report term-missing " ""
  '';

  propagatedBuildInputs = [
    pysnmp
  ];

  checkInputs = [
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [ "brother" ];

  meta = with lib; {
    description = "Python wrapper for getting data from Brother laser and inkjet printers via SNMP";
    homepage = "https://github.com/bieniu/brother";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
