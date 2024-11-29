{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "genson";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "wolverdude";
    repo = "GenSON";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bb2PRuZuj/yotb78MbLgVwi4Fz7hbnXJmoXTe4kg43k=";
  };

  build-system = [ setuptools ];

  doCheck = true;

  # Import check fails with ' ModuleNotFoundError: No module named 'genson.schema'
  # pythonImportsCheck = [ "genson" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "A powerful, user-friendly JSON Schema generator built in Python";
    homepage = "https://github.com/wolverdude/GenSON";
    downloadPage = "https://github.com/wolverdude/GenSON/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
