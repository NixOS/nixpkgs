{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymata-express";
  version = "1.21";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrYsLab";
    repo = pname;
    rev = version;
    sha256 = "1mibyn84kjahrv3kn51yl5mhkyig4piv6wanggzjflh5nm96bhy8";
  };

  propagatedBuildInputs = [
    pyserial
  ];

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
