{ lib
, buildPythonPackage
, fetchPypi
, smmap
, isPy3k
}:

buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.9";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa";
  };

  propagatedBuildInputs = [ smmap ];

  postPatch = ''
    substituteInPlace setup.py --replace ",<4" ""
  '';

  # Bunch of tests fail because they need an actual git repo
  doCheck = false;

  meta = {
    description = "Git Object Database";
    maintainers = [ ];
    homepage = "https://github.com/gitpython-developers/gitdb";
    license = lib.licenses.bsd3;
  };
}
