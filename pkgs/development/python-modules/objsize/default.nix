{ lib
, python
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "objsize";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = pname;
    rev = version;
    hash = "sha256-FgRB7EENwNOlC7ynIRxcwucoywNjko494s75kOp5O+w=";
  };

  meta = with lib; {
    description = "Traversal over objects subtree and calculate the total size";
    homepage = "https://github.com/liran-funaro/objsize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ocfox ];
  };
}
