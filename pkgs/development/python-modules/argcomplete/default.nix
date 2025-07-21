{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "3.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = "argcomplete";
    tag = "v${version}";
    hash = "sha256-2o0gQtkQP9cax/8SUd9+65TwAIAjBYnI+ufuzZtrVyo=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  # Tries to build and install test packages which fails
  doCheck = false;

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    changelog = "https://github.com/kislyuk/argcomplete/blob/${src.tag}/Changes.rst";
    downloadPage = "https://github.com/kislyuk/argcomplete";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo ];
  };
}
