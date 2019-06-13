{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "configparser";
  version = "3.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da60d0014fd8c55eb48c1c5354352e363e2d30bbf7057e5e171a468390184c75";
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
