{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "anonip";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DigitaleGesellschaft";
    repo = "Anonip";
    rev = "v${version}";
    sha256 = "0cssdcridadjzichz1vv1ng7jwphqkn8ihh83hpz9mcjmxyb94qc";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=anonip --cov-report=term-missing --no-cov-on-fail" ""
  '';

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "anonip"
  ];

  meta = with lib; {
    description = "Tool to anonymize IP addresses in log files";
    homepage = "https://github.com/DigitaleGesellschaft/Anonip";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
  };
}
