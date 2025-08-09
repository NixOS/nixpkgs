{
  buildPythonPackage,
  ebooklib,
  fetchFromGitHub,
  lib,
  lxml,
  nix-update-script,
  pillow,
  poetry-core,
  pypdf,
  python-slugify,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "comicon";
  version = "1.5.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    tag = "v${version}";
    hash = "sha256-E5Jmk/dQcEuH7kq5RL80smHUuL/Sw0F1wk4V1/4sKSQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    ebooklib
    lxml
    pillow
    pypdf
    python-slugify
  ];

  pythonRelaxDeps = [
    "ebooklib"
    "lxml"
    "pillow"
    "pypdf"
  ];

  doCheck = false; # test artifacts are not public

  pythonImportsCheck = [ "comicon" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/potatoeggy/comicon/releases/tag/v${version}";
    description = "Lightweight comic converter library between CBZ, PDF, and EPUB";
    homepage = "https://github.com/potatoeggy/comicon";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
