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
  version = "3.7.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    sha256 = "13shas7krf7j04gqxjn09ipy318hmrp1s3b5d576d5r1xfxakam4";
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
