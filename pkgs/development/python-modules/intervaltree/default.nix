{ stdenv, buildPythonPackage, fetchPypi
, python, pytest, sortedcontainers }:

buildPythonPackage rec {
  version = "3.0.2";
  pname = "intervaltree";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wz234g6irlm4hivs2qzmnywk0ss06ckagwh15nflkyb3p462kyb";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ sortedcontainers ];

  checkPhase = ''
    runHook preCheck
    rm build -rf
    ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Editable interval tree data structure for Python 2 and 3";
    homepage =  https://github.com/chaimleib/intervaltree;
    license = [ licenses.asl20 ];
    maintainers =  [ maintainers.bennofs ];
  };
}
