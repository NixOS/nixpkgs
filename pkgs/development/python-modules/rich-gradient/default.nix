{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  loguru,
  nix-update-script,
  requests,
  rich,
  rich-color-ext,
}:

buildPythonPackage rec {
  pname = "rich-gradient";
  version = "0.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxludden";
    repo = "rich-gradient";
    tag = "v${version}";
    hash = "sha256-blCvJErQMsj+nV/Djw4ltbaC0kGtkIkeNTooJTF5HkM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    loguru
    requests
    rich
    rich-color-ext
  ];

  pythonImportsCheck = [ "rich_gradient" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text gradient generator for the Rich library";
    homepage = "https://github.com/maxludden/rich-gradient";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.luochen1990 ];
  };
}
