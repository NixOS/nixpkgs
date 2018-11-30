{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "ptest";
  version =  "1.5.3";

  src = fetchFromGitHub {
    owner = "KarlGong";
    repo = pname;
    rev = version + "-release";
    sha256 = "1r50lm6n59jzdwpp53n0c0hp3aj1jxn304bk5gh830226gsaf2hn";
  };

  meta = with stdenv.lib; {
    description = "Test classes and test cases using decorators, execute test cases by command line, and get clear reports";
    homepage = https://pypi.python.org/pypi/ptest;
    license = licenses.asl20;
  };

}
