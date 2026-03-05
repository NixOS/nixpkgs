{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  poetry-core,
  rich,
}:

buildPythonPackage rec {
  pname = "pyboxen";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "savioxavier";
    repo = "pyboxen";
    tag = "v${version}";
    hash = "sha256-ck6/BocsL0Up3G561n1JmWp0Hh1wnRfA8mXFOgYpA7c=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    rich
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Incredibly customizable terminal boxes for Python";
    homepage = "https://github.com/savioxavier/pyboxen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/savioxavier/pyboxen/releases/tag/${src.tag}";
  };
}
