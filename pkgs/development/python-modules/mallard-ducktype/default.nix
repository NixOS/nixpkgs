{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mallard-ducktype";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "projectmallard";
    repo = "mallard-ducktype";
    tag = version;
    hash = "sha256-jHjzTBBRBh//bOrdnyCRmZRmpupgDaDRuZGAd75baco=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preCheck
    pushd tests
    ./runtests
    popd
    runHook postCheck
  '';

  pythonImportsCheck = [ "mallard" ];

  meta = {
    description = "Parser for the lightweight Ducktype syntax for Mallard";
    homepage = "https://github.com/projectmallard/mallard-ducktype";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
