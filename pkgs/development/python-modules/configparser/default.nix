{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "configparser";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bd5fa2a491dc3cfe920a3f2a107510d65eceae10e9c6e547b90261a4710df32";
  };

  # No tests available
  doCheck = false;

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with stdenv.lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    license = licenses.mit;
    homepage = https://github.com/jaraco/configparser;
  };
}
