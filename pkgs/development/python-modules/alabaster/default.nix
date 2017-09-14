{ stdenv, buildPythonPackage, fetchPypi
, pygments }:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.10";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37cdcb9e9954ed60912ebc1ca12a9d12178c26637abdf124e3cde2341c257fe0";
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
