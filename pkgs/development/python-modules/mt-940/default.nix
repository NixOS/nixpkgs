{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.21.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cbd88fd7252d5a2694593633b31f819eb302423058fecb9f9959e74c01c2b86";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  checkInputs = [ pyyaml pytest ];

  # requires tests files that are not present
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  pythonImportsCheck = [ "mt940" ];

  meta = with lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = "https://github.com/WoLpH/mt940";
    license = licenses.bsd3;
  };
}
