{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "munch";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ae3d26b837feacf732fb8aa5b842130da1daf221f5af9f9d4b2a0a6414b0d51";
  };

  propagatedBuildInputs = [ six ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A dot-accessible dictionary (a la JavaScript objects)";
    license = licenses.mit;
    homepage = https://github.com/Infinidat/munch;
  };

}
