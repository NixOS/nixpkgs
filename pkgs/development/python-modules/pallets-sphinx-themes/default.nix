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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "pallets-sphinx-themes";
    tag = version;
    hash = "sha256-+etmWzjCiYbM8cHSnJr0tHs3DpvozNYShQ6x60UADS4=";
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
