{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, bottle
}:

buildPythonPackage rec {
  pname = "boddle";
  version = "0.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "keredson";
    repo = pname;

    # upstream doesn't tag releases
    # https://github.com/keredson/boddle/issues/14
    rev = "74413e4c5b39a37ea1694fab07b459ccd2998390";
    hash = "sha256-iyxgdUM3NEbDaRd8ogCsxyNPF0nMuIV2S4FiFAZJXrY=";
  };

  propagatedBuildInputs = [ bottle ];

  pythonImportsCheck = [
    "boddle"
  ];

  meta = with lib; {
    description = "Unit testing tool for Python's bottle library";
    homepage = "https://github.com/keredson/boddle";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
