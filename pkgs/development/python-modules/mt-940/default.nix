{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.15.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c1d5c23a9c3fec12a61ce3f61d8be107b4693be4a4b97381eca23f4a4dca8ed";
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
