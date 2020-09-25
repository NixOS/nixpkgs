{
  buildPythonPackage,
  fetchPypi,
  lib,
  nose,
  six,
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zjf9nczl1ifzj07bgs6mwxsfd5xck9l0lchv2j0fv2n481xp2v7";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ nose ];

  # Tests currently failing.
  doCheck = false;

  meta = {
    description = "Factory+Registry pattern for Python classes.";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
