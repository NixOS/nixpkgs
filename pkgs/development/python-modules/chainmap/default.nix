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
    hash = "sha256-5CqqSz4vZhAqEb/VYwaXBL+/2E/ctRe1ZO/9c2v1PNk=";
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
