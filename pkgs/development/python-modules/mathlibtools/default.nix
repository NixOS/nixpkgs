{ lib, buildPythonPackage, fetchPypi, PyGithub, GitPython, toml, click, tqdm,
  paramiko, networkx, pydot, pyyaml }:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "0.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d708bgsxjhhchqc56afi1h7k87vbfn7v40f4y1zlv7hsjc69s36";
  };

  requiredPythonModules = [
    PyGithub GitPython toml click tqdm paramiko networkx pydot pyyaml
  ];

  # requires internet access
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/leanprover-community/mathlib-tools";
    description = "leanproject is a supporting tool for Lean's mathlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
