{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  torch,
}:

buildPythonPackage rec {
  pname = "lion-pytorch";
  version = "0.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "lion-pytorch";
    tag = version;
    hash = "sha256-RHixPIZ1kCawWQiqYqLY+c3r6Rg86LKm3tQTyW2BNFU=";
  };

  propagatedBuildInputs = [ torch ];

  pythonImportsCheck = [ "lion_pytorch" ];
  doCheck = false; # no tests currently

  meta = {
    description = "Optimizer tuned by Google Brain using genetic algorithms";
    homepage = "https://github.com/lucidrains/lion-pytorch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
