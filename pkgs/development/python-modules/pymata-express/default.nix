{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymata-express";
  version = "1.20";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrYsLab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-spYmd+Cb7Ej5FmniuJYAVVmq0mhOz5fu4+2UUXctRWs=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pymata_express" ];

  meta = with lib; {
    description = "Python Asyncio Arduino Firmata Client";
    longDescription = ''
      Pymata-Express is a Python Firmata Protocol client. When used in conjunction
      with an Arduino Firmata sketch, it permits you to control and monitor Arduino
      hardware remotely over a serial link.
    '';
    homepage = "https://mryslab.github.io/pymata-express/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
