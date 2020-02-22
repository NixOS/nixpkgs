{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "google-pasta";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "713813a9f7d6589e5defdaf21e80e4392eb124662f8bd829acd51a4f8735c0cb";
  };

  propagatedBuildInputs = [
    six
  ];

  meta = {
    description = "An AST-based Python refactoring library";
    homepage    = https://github.com/google/pasta;
    license     = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timokau ];
  };
}
