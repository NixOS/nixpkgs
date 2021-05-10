{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, attrs
, isodate
, dateutil
, rfc3986
, uritemplate
, mock
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "csvw";
  version = "1.11.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "1393xwqawaxsflbq62vks92vv4zch8p6dd1mdvdi7j4vvf0zljkg";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  propagatedBuildInputs = [
    attrs
    isodate
    dateutil
    rfc3986
    uritemplate
  ];

  checkInputs = [
    mock
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
