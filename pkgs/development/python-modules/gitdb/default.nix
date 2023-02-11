{ lib
, buildPythonPackage
, fetchPypi
, smmap
, isPy3k
}:

buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.10";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-brmQtp304VutiZ6oaNxGVyw/dTOXNWY7gd55sG8X65o=";
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
