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
  version = "1.10.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "0z0qxlsfxwz1qapxb4d0mz3wkj99d7zi9yrg1cbd2xp7giagb6d4";
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
