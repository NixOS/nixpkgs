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
  version = "3.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = "argcomplete";
    tag = "v${version}";
    hash = "sha256-rxo27SCOQxauMbC7GK3co/HZK8cRqbqHyk9ORQYHta4=";
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
