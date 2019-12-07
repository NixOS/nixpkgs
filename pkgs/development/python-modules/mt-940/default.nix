{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.18.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5b6469e9bc64522125efae1de0e557f76884c961f122028098533d6f2a98f23";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  checkInputs = [ pyyaml pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = https://github.com/WoLpH/mt940;
    license = licenses.bsd3;
  };
}
