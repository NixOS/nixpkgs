{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kaleido";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "Kaleido";
    rev = "refs/tags/v${version}.post1";
    hash = "sha256-D9ttX1EefoM9KN6kdXqk/SgGCKE1vv8ayxbl8A1rJHg=";
  };

  sourceRoot = "${src.name}/repos/kaleido/py";

  postPatch = ''
    # this file is ignored on the repository, but required to build
    echo "__version__ = '${version}'" > kaleido/_version.py
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [
    "kaleido"
    "kaleido.scopes"
  ];

  doCheck = false; # requires network to fetch data

  meta = {
    description = "Fast static image export for web-based visualization libraries with zero dependencies";
    homepage = "https://github.com/plotly/Kaleido";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
