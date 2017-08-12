{ stdenv, buildPythonPackage, fetchPypi
, pytest }:

buildPythonPackage rec {
  pname = "apipkg";
  version = "1.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e38399dbe842891fe85392601aab8f40a8f4cc5a9053c326de35a1cc0297ac6";
  };

  buildInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Namespace control and lazy-import mechanism";
    homepage = http://bitbucket.org/hpk42/apipkg;
    license = licenses.mit;
  };
}
