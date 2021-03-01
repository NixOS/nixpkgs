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
  version = "1.10.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "0cvfzfi1a2m1xqpm34mwp9r3bhgsnfz4pmslvgn81i42n5grbnis";
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
