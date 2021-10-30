{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, attrs
, colorlog
, csvw
, python-dateutil
, tabulate
, mock
, postgresql
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.9.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    sha256 = "07ljq7v1zvaxyl6xn4a2p4097lgd5j9bz71lf05y5bz8k024mxbr";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  propagatedBuildInputs = [
    python-dateutil
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
    maintainers = with maintainers; [ ];
  };
}
