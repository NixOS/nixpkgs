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
  version = "3.5.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qlqp9yq4lbi9ik2psgw0svxlb7raadqaxdh2dgkn85d7h20y4nd";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  requiredPythonModules = [
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
