{ lib
, buildPythonPackage
, fetchFromGitHub
, pysnmplib
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "brother";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pxFp/CSoskAx6DdZlkBRvocUJ5Kt5ymPwxpLhT743uE=";
  };

  propagatedBuildInputs = [
    pysnmplib
  ];

  checkInputs = [
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov --cov-report term-missing " ""
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
    substituteInPlace requirements.txt \
      --replace "pysnmplib==" "pysnmplib>="
  '';

  pythonImportsCheck = [
    "brother"
  ];

  meta = with lib; {
    description = "Python wrapper for getting data from Brother laser and inkjet printers via SNMP";
    homepage = "https://github.com/bieniu/brother";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
