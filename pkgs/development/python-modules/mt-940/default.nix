{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.19.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d109e8dc4b490a4b92ec0153713710eb067b36b350ce1ff60c406afddc7d3cd";
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
