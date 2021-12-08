{ lib
, buildPythonPackage
, fetchFromGitHub
, JPype1
}:

buildPythonPackage rec {
  pname = "JayDeBeApi";
  version = "1.2.3";

  src = fetchFromGitHub {
     owner = "baztian";
     repo = "jaydebeapi";
     rev = "v1.2.3";
     sha256 = "08xhrxmc167hdylzvjfi392q0a6v2g9lwwr4nprlr2fbqfq2h29y";
  };

  propagatedBuildInputs = [
    JPype1
  ];

  meta = with lib; {
    homepage = "https://github.com/baztian/jaydebeapi";
    license = licenses.lgpl2;
    description = "Use JDBC database drivers from Python 2/3 or Jython with a DB-API";
  };
}
