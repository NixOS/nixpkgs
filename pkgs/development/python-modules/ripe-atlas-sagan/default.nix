{ lib
, buildPythonPackage
, python-dateutil
, pytz
, cryptography
, nose
, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "ripe-atlas-sagan";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-sagan";
    rev = "v${version}";
    sha256 = "sha256-xIBIKsQvDmVBa/C8/7Wr3WKeepHaGhoXlgatXSUtWLA=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
    cryptography
  ];

  checkInputs = [
    nose
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A parsing library for RIPE Atlas measurements results.";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-sagan";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
