{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "chainmap";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e42aaa4b3e2f66102a11bfd563069704bfbfd84fdcb517b564effd736bf53cd9";
  };

  # Requires tox
  doCheck = false;

  meta = with lib; {
    description = "Backport/clone of ChainMap";
    homepage = "https://bitbucket.org/jeunice/chainmap";
    license = licenses.psfl;
    maintainers = with maintainers; [ abbradar ];
  };
}
