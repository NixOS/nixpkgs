{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  torch,
}:

buildPythonPackage rec {
  pname = "lion-pytorch";
  version = "0.2.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "lion-pytorch";
    rev = "refs/tags/${version}";
    hash = "sha256-hOPTuXdTrTi/Thv3/5IYqkgH+5cFdzyK1Fshus8u5n0=";
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
