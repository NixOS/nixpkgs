{ lib, buildPythonPackage, fetchPypi, pythonOlder
, python, pycares, typing ? null
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "2.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "815fdef4607474295d68da46978a54481dd1e7be153c7d60f9e72773cd38d77d";
  };

  propagatedBuildInputs = [ pycares ]
    ++ lib.optional (pythonOlder "3.7") typing;

  checkPhase = ''
    ${python.interpreter} tests.py
  '';

  # 'Could not contact DNS servers'
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/saghul/aiodns";
    license = licenses.mit;
    description = "Simple DNS resolver for asyncio";
  };
}
