{
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pytest,
}:

buildPythonPackage rec {
  pname = "itypes";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "tomchristie";
    rev = version;
    sha256 = "1ljhjp9pacbrv2phs58vppz1dlxix01p98kfhyclvbml6dgjcr52";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    mv itypes.py itypes.py.hidden
    pytest tests.py
  '';

  meta = with stdenv.lib; {
    description = "Simple immutable types for python";
    homepage = "https://github.com/tomchristie/itypes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ivegotasthma ];
  };
}
