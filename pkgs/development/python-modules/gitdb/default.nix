{ lib
, buildPythonPackage
, fetchPypi
, smmap
, isPy3k
}:

buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l113fphn6msjl3cl3kyf332b6lal7daxdd0nfma0x9ipfb013jr";
  };

  propagatedBuildInputs = [ smmap ];

  # Bunch of tests fail because they need an actual git repo
  doCheck = false;

  meta = {
    description = "Git Object Database";
    maintainers = [ ];
    homepage = https://github.com/gitpython-developers/gitdb;
    license = lib.licenses.bsd3;
  };
}
