{ lib
, buildPythonPackage
, fetchPypi
, smmap
, isPy3k
}:

buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.7";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005";
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
