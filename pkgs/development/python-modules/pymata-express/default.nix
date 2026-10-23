{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pymata-express";
  version = "1.21";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MrYsLab";
    repo = "pymata-express";
    rev = version;
    hash = "sha256-yMNlUrUFUif/e1Zxs+MlL/oJa6E+FDvHzlDJSZD1K9Y=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymata_express" ];

  meta = {
    description = "Python Asyncio Arduino Firmata Client";
    longDescription = ''
      Pymata-Express is a Python Firmata Protocol client. When used in conjunction
      with an Arduino Firmata sketch, it permits you to control and monitor Arduino
      hardware remotely over a serial link.
    '';
    homepage = "https://mryslab.github.io/pymata-express/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
