{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80f977667ebbad2b5c4f7b7f45ee8bea6622fb71723f68a9a8fe6274520c853b";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "dpkt" ];

  meta = with lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
