{ lib
, buildPythonPackage
, fetchFromGitHub
, pysnmp
, pytest-asyncio
, pytest-error-for-skips
, pytest-runner
, pytest-tornasync
, pytest-trio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "brother";
  version = "0.2.2";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-vIefcL3K3ZbAUxMFM7gbbTFdrnmufWZHcq4OA19SYXE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov --cov-report term-missing " ""
    substituteInPlace requirements-test.txt \
      --replace "pytest-cov" ""
  '';

  propagatedBuildInputs = [
    pysnmp
  ];

  checkInputs = [
    pytest-asyncio
    pytest-error-for-skips
    pytest-runner
    pytest-tornasync
    pytest-trio
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
