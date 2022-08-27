{ lib, buildPythonPackage, fetchPypi, PyGithub, GitPython, toml, click, tqdm,
  networkx, pydot, pyyaml, atomicwrites }:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Jbnb3FKyB1NAehB8tZxBV6d7JJCOgWZPMWMaFEAOzkM=";
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
