{ buildPythonPackage, fetchPypi, lib, nose, }:

buildPythonPackage rec {
  pname = "nose-timer";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f70d103b7ffd9122a589de0df9d037a7d967519bf6de122621d2186609b9e3a";
  };

  propagatedBuildInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/mahmoudimus/nose-timer";
    license = licenses.mit;
    description = "A timer plugin for nosetests (how much time does every test take?)";
    maintainers = with maintainers; [ doronbehar ];
  };
}
