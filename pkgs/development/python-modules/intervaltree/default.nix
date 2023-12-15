{ lib, buildPythonPackage, fetchPypi
, python, pytest, sortedcontainers }:

buildPythonPackage rec {
  version = "3.1.0";
  format = "setuptools";
  pname = "intervaltree";

  src = fetchPypi {
    inherit pname version;
    sha256 = "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ sortedcontainers ];

  checkPhase = ''
    runHook preCheck
    rm build -rf
    ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Editable interval tree data structure for Python 2 and 3";
    homepage =  "https://github.com/chaimleib/intervaltree";
    license = [ licenses.asl20 ];
    maintainers =  [ maintainers.bennofs ];
  };
}
