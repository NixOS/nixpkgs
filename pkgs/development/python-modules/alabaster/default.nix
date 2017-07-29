{ stdenv, buildPythonPackage, fetchPypi
, pygments }:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f416a84e0d0ddbc288f6b8f2c276d10b40ca1238562cd9ed5a751292ec647b71";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bitprophet/alabaster;
    description = "A Sphinx theme";
    license = licenses.bsd3;
  };
}
