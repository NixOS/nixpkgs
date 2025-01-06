{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "3.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = "argcomplete";
    tag = "v${version}";
    hash = "sha256-Tihb61LGTZ8tKrKKlxZ8scII2+pgzDHUkwVn54zlrug=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Tries to build and install test packages which fails
  doCheck = false;

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    changelog = "https://github.com/kislyuk/argcomplete/blob/v${version}/Changes.rst";
    downloadPage = "https://github.com/kislyuk/argcomplete";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo ];
  };
}
