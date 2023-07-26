{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, torch
}:

buildPythonPackage rec {
  pname = "lion-pytorch";
  version = "0.1.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "lion-pytorch";
    rev = "refs/tags/${version}";
    hash = "sha256-9hdpRJvCpv3PeC7f0IXpHt6i+e6LiT0QUl5jeDGelQE=";
  };

  propagatedBuildInputs = [ torch ];

  pythonImportsCheck = [ "lion_pytorch" ];
  doCheck = false;  # no tests currently

  meta = with lib; {
    description = "Optimizer tuned by Google Brain using genetic algorithms";
    homepage = "https://github.com/lucidrains/lion-pytorch";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
