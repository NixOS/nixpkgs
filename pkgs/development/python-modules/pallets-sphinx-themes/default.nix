{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit,
  packaging,
  pythonOlder,
  sphinx,
  sphinx-notfound-page,
}:

buildPythonPackage rec {
  pname = "pallets-sphinx-themes";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "pallets-sphinx-themes";
    rev = "refs/tags/${version}";
    sha256 = "sha256-+etmWzjCiYbM8cHSnJr0tHs3DpvozNYShQ6x60UADS4=";
  };

  build-system = [ flit ];

  dependencies = [
    packaging
    sphinx
    sphinx-notfound-page
  ];

  pythonImportsCheck = [ "pallets_sphinx_themes" ];

  meta = {
    homepage = "https://github.com/pallets/pallets-sphinx-themes";
    description = "Sphinx theme for Pallets projects";
    changelog = "https://github.com/pallets/pallets-sphinx-themes/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
