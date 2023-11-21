{ lib
, buildPythonPackage
, fetchPypi
, smmap
, isPy3k
}:

buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.11";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v1QhEmE21tCvVbwefBrxw5ejT1t71553bNPol4XCsEs=";
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
