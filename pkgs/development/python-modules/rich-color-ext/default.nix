{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  loguru,
  nix-update-script,
  rich,
}:

buildPythonPackage rec {
  pname = "rich-color-ext";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxludden";
    repo = "rich-color-ext";
    tag = "v${version}";
    hash = "sha256-lqcve6txI/QhK230kPD1V0cG76qXY6JwKuNSbQ/zNLk=";
  };

  # Upstream mistakenly lists pytest as a runtime dependency.
  pythonRemoveDeps = [ "pytest" ];

  build-system = [ hatchling ];

  dependencies = [
    loguru
    rich
  ];

  pythonImportsCheck = [ "rich_color_ext" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extra named CSS colors and HEX utilities for Rich";
    homepage = "https://github.com/maxludden/rich-color-ext";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.luochen1990 ];
  };
}
