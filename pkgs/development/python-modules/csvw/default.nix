{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
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
  version = "1.8.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "0maxrsiv9i9hkg627hwqyq8g6jg3g8iv8gdqaxz4aysjd9xddydd";
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
