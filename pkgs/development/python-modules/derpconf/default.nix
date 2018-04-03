{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "derpconf";
  version = "0.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0si3xnhyjk8dykr377v35bldsjv1ikgx4ff3crizwxv47ag42aci";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "derpconf abstracts loading configuration files for your app";
    homepage = https://github.com/globocom/derpconf;
    license = licenses.mit;
  };
}
