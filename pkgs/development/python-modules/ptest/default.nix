{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "ptest";
  version =  "1.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KarlGong";
    repo = pname;
    rev = version + "-release";
    sha256 = "0v1zpfjagjlvdmgv6d502nmb7s996wadvpzg93i651s64rrlwq4s";
  };

  meta = with lib; {
    description = "Test classes and test cases using decorators, execute test cases by command line, and get clear reports";
    homepage = "https://pypi.python.org/pypi/ptest";
    license = licenses.asl20;
  };

}
