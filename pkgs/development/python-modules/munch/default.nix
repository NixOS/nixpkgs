{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "munch";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1420683a94f3a2ffc77935ddd28aa9ccb540dd02b75e02ed7ea863db437ab8b2";
  };

  meta = with stdenv.lib; {
    description = "A dot-accessible dictionary (a la JavaScript objects)";
    license = licenses.mit;
    homepage = https://github.com/Infinidat/munch;
  };

}
