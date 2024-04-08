{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "conway-polynomials";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-btIwBgm8558BddW4VGhY7sAoVPi+MjfbjRRJzMzBxYE=";
  };

  pythonImportsCheck = [ "conway_polynomials" ];

  meta = with lib; {
    description = "Python interface to Frank Lübeck's Conway polynomial database";
    homepage = "https://github.com/sagemath/conway-polynomials";
    maintainers = teams.sage.members;
    license = licenses.gpl3Plus;
  };
}
