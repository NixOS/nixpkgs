{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.59";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4406d9bf49d570ef0ba80be9cf8eb4bd75c08a2909369ebd90b8e94ff07f116e";
  };

  # PyPI tarball does not include tests/ directory
  # Unreliable timing: https://github.com/danielperna84/pyhomematic/issues/126
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = https://github.com/danielperna84/pyhomematic;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
