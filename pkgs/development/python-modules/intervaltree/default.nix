{ lib, buildPythonPackage, fetchFromGitHub
, python, pytest, sortedcontainers }:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "intervaltree";

  src = fetchFromGitHub {
     owner = "chaimleib";
     repo = "intervaltree";
     rev = "3.1.0";
     sha256 = "0d9jfbramihsg7d2axxh4s3kkkrbd6ch555nf7g1l3zjxvp8kxw9";
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
