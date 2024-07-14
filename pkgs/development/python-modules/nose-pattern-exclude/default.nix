{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  pname = "nose-pattern-exclude";
  version = "0.1.3";
  format = "setuptools";

  propagatedBuildInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mdio/BbyJifGNjcu18pG+NzSrQ4cd3Vpp01vRVHv/yo=";
  };

  # There are no tests
  doCheck = false;

  meta = with lib; {
    description = "Exclude specific files and directories from nosetests runs";
    homepage = "https://github.com/jakubroztocil/nose-pattern-exclude";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
