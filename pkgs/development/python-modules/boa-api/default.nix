{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "boa-api";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "boalang";
    repo = "api-python";
    rev = "v${version}";
    sha256 = "sha256-8tt68NLi5ewSKiHdu3gDawTBPylbDmB4zlUUqa7EQuY=";
  };

  pythonImportsCheck = [ "boaapi" ];

  meta = {
    homepage = "https://github.com/boalang/api-python";
    description = "Python client API for communicating with Boa's (https://boa.cs.iastate.edu/) XML-RPC based services";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
