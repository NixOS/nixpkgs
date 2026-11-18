{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  packaging,
  flit-core,
  sphinx-notfound-page,
}:

buildPythonPackage rec {
  pname = "pallets-sphinx-themes";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "pallets-sphinx-themes";
    tag = version;
    hash = "sha256-nmukg/h6DMv6t0wl84VEvHIHzk0G0VDaHZsb8y+OO4M=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    packaging
    sphinx
    sphinx-notfound-page
  ];

  pythonImportsCheck = [ "pallets_sphinx_themes" ];

  meta = {
    homepage = "https://github.com/pallets/pallets-sphinx-themes";
    description = "Sphinx theme for Pallets projects";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
