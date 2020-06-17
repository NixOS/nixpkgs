{ lib
, buildPythonPackage
, fetchPypi
, smmap
, isPy3k
}:

buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9";
  };

  propagatedBuildInputs = [ smmap ];

  # Bunch of tests fail because they need an actual git repo
  doCheck = false;

  meta = {
    description = "Git Object Database";
    maintainers = [ ];
    homepage = "https://github.com/gitpython-developers/gitdb";
    license = lib.licenses.bsd3;
  };
}
