{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "chainmap";
  version = "1.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09h5gq43w516fqswlca0nhmd2q3v8hxq15z4wqrznfwix6ya6pa0";
  };

  # Requires tox
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Backport/clone of ChainMap";
    homepage = "https://bitbucket.org/jeunice/chainmap";
    license = licenses.psfl;
    maintainers = with maintainers; [ abbradar ];
  };
}
