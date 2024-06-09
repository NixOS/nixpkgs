{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  torch,
}:

buildPythonPackage rec {
  pname = "lion-pytorch";
  version = "0.1.4";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "lion-pytorch";
    rev = "refs/tags/${version}";
    hash = "sha256-8LbALBKQ5ACwmLWYUz3GYkkkhhy8emi6n3kgwYdnDSI=";
  };

  propagatedBuildInputs = [ torch ];

  pythonImportsCheck = [ "lion_pytorch" ];
  doCheck = false; # no tests currently

  meta = with lib; {
    description = "Optimizer tuned by Google Brain using genetic algorithms";
    homepage = "https://github.com/lucidrains/lion-pytorch";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
