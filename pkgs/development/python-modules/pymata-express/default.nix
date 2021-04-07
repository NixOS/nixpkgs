{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymata-express";
  version = "1.19";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrYsLab";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gfjmqcxwsnfjgll6ql5xd1n3xp4klf4fcaajaivh053i02p0a79";
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
