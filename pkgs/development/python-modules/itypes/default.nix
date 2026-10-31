{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytest,
}:

buildPythonPackage rec {
  pname = "itypes";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "itypes";
    owner = "tomchristie";
    rev = version;
    hash = "sha256-omQmXzO0rk2Zh26idAPosdMW/r0bFQ2v2HkxddOVUNI=";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    mv itypes.py itypes.py.hidden
    pytest tests.py
  '';

  meta = {
    description = "Simple immutable types for python";
    homepage = "https://github.com/tomchristie/itypes";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
