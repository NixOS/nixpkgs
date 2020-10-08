{ buildPythonPackage, fetchPypi, lib, nose, }:

buildPythonPackage rec {
  pname = "nose-timer";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09hwjwbczi06bfqgiylb2yxs5h88jdl26zi1fdqxdzvamrkksf2c";
  };

  propagatedBuildInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/mahmoudimus/nose-timer";
    license = licenses.mit;
    description = "A timer plugin for nosetests (how much time does every test take?)";
    maintainers = with maintainers; [ doronbehar ];
  };
}
