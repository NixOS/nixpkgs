{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "3.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = "argcomplete";
    tag = "v${version}";
    hash = "sha256-GK78gW54cFE0yXra56wG8LnBL9CLbf0TuIgxFwA9zZY=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  # Tries to build and install test packages which fails
  doCheck = false;

  pythonImportsCheck = [ "argcomplete" ];

  meta = {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    changelog = "https://github.com/kislyuk/argcomplete/blob/${src.tag}/Changes.rst";
    downloadPage = "https://github.com/kislyuk/argcomplete";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ womfoo ];
  };
}
