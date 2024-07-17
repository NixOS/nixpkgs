{ buildPythonPackage, pythonOlder }:

buildPythonPackage {

  pname = "typeddep";
  version = "1.3.3.7";

  src = ./.;

  disabled = pythonOlder "3.7";

}
