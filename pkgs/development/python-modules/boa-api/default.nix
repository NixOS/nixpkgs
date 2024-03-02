{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "boa-api";
  version = "0.1.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "boalang";
    repo = "api-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-8tt68NLi5ewSKiHdu3gDawTBPylbDmB4zlUUqa7EQuY=";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "boaapi"
  ];

  meta = {
    homepage = "https://github.com/boalang/api-python";
    description = "Python client API for communicating with Boa's (https://boa.cs.iastate.edu/) XML-RPC based services";
    changelog = "https://github.com/boalang/api-python/blob/${src.rev}/Changes.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
