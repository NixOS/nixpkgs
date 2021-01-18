{ lib, buildPythonPackage, fetchPypi, PyGithub, GitPython, toml, click, tqdm,
  paramiko, networkx, pydot, pyyaml }:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da41c65e206f55b1faea303581fc11215e52d6e6990b827336b2e1eb82aad96c";
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
