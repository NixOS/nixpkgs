{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, click-log
, paho-mqtt
, pyaml
}:

buildPythonPackage rec {
  pname = "bch";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-control-tool";
    rev = "v${version}";
    sha256 = "/C+NbJ0RrWZ/scv/FiRBTh4h7u0xS4mHVDWQ0WwmlEY=";
  };

  propagatedBuildInputs = [
    click
    click-log
    paho-mqtt
    pyaml
  ];

  postPatch = ''
    sed -ri 's/@@VERSION@@/${version}/g' \
      bch/cli.py setup.py
  '';

  pythonImportsCheck = [ "bch" ];

  meta = with lib; {
    homepage = "https://github.com/hardwario/bch-control-tool";
    description = "HARDWARIO Hub Control Tool";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
