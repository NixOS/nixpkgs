# Package definition for langgraph-runtime-inmem-open
# This should be added to pkgs/development/python-modules/langgraph-runtime-inmem-open.nix

{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "langgraph-runtime-inmem-open";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "AbdulmalikDS";
    repo = "langgraph-runtime-inmem-open";
    rev = "v${version}";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # This will be updated by nix-prefetch-git
  };

  format = "pyproject";

  propagatedBuildInputs = with python3.pkgs; [
    langgraph
    pydantic
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  checkInputs = with python3.pkgs; [
    pytest
    pytest-cov
    pytest-asyncio
    flake8
    black
    isort
    mypy
    pylint
  ];

  pythonImportsCheck = [ "langgraph_runtime_inmem_open" ];

  doCheck = true;

  meta = with lib; {
    description = "Open-source alternative to langgraph-runtime-inmem";
    homepage = "https://github.com/AbdulmalikDS/langgraph-runtime-inmem-open";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix ++ platforms.darwin;
    broken = false;
  };
} 