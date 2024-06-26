{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  click,
  click-log,
  paho-mqtt,
  pyaml,
  pyserial,
  schema,
  simplejson,
}:
buildPythonPackage rec {
  pname = "bcg";
  version = "1.17.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-gateway";
    rev = "v${version}";
    sha256 = "2Yh5MeIv+BIxjoO9GOPqq7xTAFhyBvnxPy7DeO2FrkI=";
  };

  postPatch = ''
    sed -ri 's/@@VERSION@@/${version}/g' \
      bcg/__init__.py setup.py
  '';

  propagatedBuildInputs = [
    appdirs
    click
    click-log
    paho-mqtt
    pyaml
    pyserial
    schema
    simplejson
  ];

  pythonImportsCheck = [ "bcg" ];

  meta = with lib; {
    homepage = "https://github.com/hardwario/bch-gateway";
    description = "HARDWARIO Gateway (Python Application «bcg»)";
    mainProgram = "bcg";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
