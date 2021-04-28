{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, attrs
, colorlog
, csvw
, dateutil
, tabulate
, mock
, postgresql
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.8.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    sha256 = "18sjcqzprf96s7bkn5zm3lh83hxfxj56nycxyldrwz7ndgkgxxx2";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  propagatedBuildInputs = [
    dateutil
    tabulate
    colorlog
    attrs
    csvw
  ];

  checkInputs = [
    mock
    postgresql
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    description = "CSV on the Web";
    homepage = "https://github.com/cldf/csvw";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
