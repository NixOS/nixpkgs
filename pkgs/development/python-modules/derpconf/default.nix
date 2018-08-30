{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "derpconf";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce4f0cd55d367a3357538a18422c916dced0617a00056b4ebabe775059eace4f";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "derpconf abstracts loading configuration files for your app";
    homepage = https://github.com/globocom/derpconf;
    license = licenses.mit;
  };
}
