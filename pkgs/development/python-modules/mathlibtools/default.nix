{ lib, buildPythonPackage, fetchPypi, PyGithub, GitPython, toml, click, tqdm,
  paramiko, networkx, pydot, pyyaml }:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "789f070f35424e89e4f2e2c007382250133cc48877627e37c5c463bcf4a1b58a";
  };

  propagatedBuildInputs = [
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
