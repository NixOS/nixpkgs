{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, numpy
, future
, pyparsing
, psutil
, pyzmq
}:

buildPythonPackage rec {
  pname = "OMPython";
  version = "3.3.0";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ff325723db358f96d64d1c0621ca2fd8b3cd41c1a6dfe122b761facafa05c8c";
  };

  propagatedBuildInputs = [ numpy future pyparsing psutil pyzmq ];

  meta = with lib; {
    description = "OpenModelica Python interface that uses ZeroMQ";
    homepage = "https://github.com/OpenModelica/OMPython";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ balodja ];
  };
}
