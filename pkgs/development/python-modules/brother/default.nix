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
  version = "1.0.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-0NfqPlQiOkNhR+H55E9LE4dGa9R8vcSyPNbbIeiRJV8=";
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
