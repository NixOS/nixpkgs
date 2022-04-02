{ lib, buildPythonPackage, fetchPypi, PyGithub, GitPython, toml, click, tqdm,
  networkx, pydot, pyyaml, atomicwrites }:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0iW7SWIxb+Ek4T26hru5EgBgXfqRh6zOR73GAgLFNyE=";
  };

  propagatedBuildInputs = [
    PyGithub GitPython toml click tqdm networkx pydot pyyaml atomicwrites
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
