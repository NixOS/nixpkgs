{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysmt";
  version = "0.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pysmt";
    repo = "pysmt";
    rev = "v${version}";
    hash = "sha256-MCw2a3KLROBwc0NHBz0Qf6YAsVfDt8pqyVL3G2ZkbZg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysmt" ];

  meta = {
    description = "Python library for SMT formulae manipulation and solving";
    mainProgram = "pysmt-install";
    homepage = "https://github.com/pysmt/pysmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
