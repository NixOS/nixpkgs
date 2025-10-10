{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  torch,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torchdiffeq";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tQ03YNE/0TjczqxlH0uAOW9E/vzr0DegM/7P6qnMEuc=";
  };

  propagatedBuildInputs = [
    torch
    scipy
  ];

  pythonImportsCheck = [ "torchdiffeq" ];

  # no tests in sdist, no tags on git
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Differentiable ODE solvers with full GPU support and O(1)-memory backpropagation";
    homepage = "https://github.com/rtqichen/torchdiffeq";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
