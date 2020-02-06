{
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pytest,
}:

buildPythonPackage rec {
  pname = "itypes";
  version = "1.1.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "tomchristie";
    rev = version;
    sha256 = "0zkhn16wpslkxkq77dqw5rxa28nrchcb6nd3vgnxv91p4skyfm62";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    mv itypes.py itypes.py.hidden
    pytest tests.py
  '';

  meta = with stdenv.lib; {
    description = "Simple immutable types for python";
    homepage = https://github.com/tomchristie/itypes;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ivegotasthma ];
  };
}
