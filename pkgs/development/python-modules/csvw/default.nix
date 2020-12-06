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
  version = "1.8.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "1cafwgkspkc299shsa5x8wfzkx1d63p9rvslj9jwr68fipd1830w";
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
