{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ngxparse";
  version = "0.5.16";
  pyproject = true;

  # Fetching from GitHub because the PyPI sdist is missing the test fixtures
  src = fetchFromGitHub {
    owner = "dvershinin";
    repo = "crossplane";
    tag = "v${version}";
    hash = "sha256-gXzVjY89YjppneR9Vuce+V+RKIcbIBEvLeAoI54ZegM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The ngxparse distribution ships its importable module as `crossplane`
  # (it's a drop-in replacement for the upstream nginxinc/crossplane).
  pythonImportsCheck = [ "crossplane" ];

  meta = {
    description = "Reliable and fast NGINX configuration file parser (maintained fork of crossplane)";
    homepage = "https://github.com/dvershinin/crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvershinin ];
  };
}
